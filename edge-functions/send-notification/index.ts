// Supabase Edge Function — send-notification
// A deployer dans le projet Supabase dedie a LAT SCANNER INVENTAIRE (independant de APEX1/APEX2).
// Reprend le pattern existant de apex (pending_notification + cron pg_cron toutes les 5 min).
// Secret requis : RESEND_API_KEY (Supabase Edge Function Secrets).

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY')!;
const EMAIL_FROM = 'rapport@rtacoulee.com';
const EMAIL_TO = ['destinataire@exemple.com'];

async function sb(path: string) {
  const res = await fetch(SUPABASE_URL + '/rest/v1/' + path, {
    headers: {
      apikey: SUPABASE_SERVICE_KEY,
      Authorization: 'Bearer ' + SUPABASE_SERVICE_KEY,
    },
  });
  return res.json();
}

Deno.serve(async () => {
  const attentes = await sb(
    'notifications_attente?select=*,historique(*)&envoye=eq.false&order=declenche_le.asc&limit=20'
  );

  if (!attentes.length) {
    return new Response(JSON.stringify({ envoyees: 0 }), { status: 200 });
  }

  const lignes = attentes.map((n: any) => {
    const h = n.historique;
    return `
      <tr>
        <td>${h.no_piece}</td>
        <td>${h.nouveau_statut}</td>
        <td>${h.type_action}</td>
        <td>${h.code_position || ''}</td>
        <td>${h.debut_statut}</td>
        <td>${h.fin_statut || ''}</td>
      </tr>`;
  }).join('');

  const html = `
    <h2>LAT Scanner Inventaire — Notifications de changement</h2>
    <table border="1" cellpadding="6" style="border-collapse:collapse">
      <tr>
        <th>No. piece</th><th>Status</th><th>Action a fait</th>
        <th>Position</th><th>Debut de status</th><th>Fin de status</th>
      </tr>
      ${lignes}
    </table>`;

  const reponseCourriel = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: 'Bearer ' + RESEND_API_KEY,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      from: EMAIL_FROM,
      to: EMAIL_TO,
      subject: 'LAT Scanner Inventaire — changements récents',
      html,
    }),
  });

  if (!reponseCourriel.ok) {
    return new Response(await reponseCourriel.text(), { status: 500 });
  }

  const ids = attentes.map((n: any) => n.id);
  await fetch(SUPABASE_URL + '/rest/v1/notifications_attente?id=in.(' + ids.join(',') + ')', {
    method: 'PATCH',
    headers: {
      apikey: SUPABASE_SERVICE_KEY,
      Authorization: 'Bearer ' + SUPABASE_SERVICE_KEY,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ envoye: true }),
  });

  return new Response(JSON.stringify({ envoyees: ids.length }), { status: 200 });
});
