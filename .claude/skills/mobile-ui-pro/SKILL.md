---
name: mobile-ui-pro
description: Professional mobile UI/UX design guidance for touch-friendly, accessible mobile applications. Use when designing mobile interfaces, responsive layouts, or touch interactions. Covers navigation patterns, touch targets, safe areas, and mobile-first best practices.
when_to_use: Use when creating mobile apps, redesigning for mobile, implementing bottom navigation, designing touch interactions, working with mobile gestures, creating responsive layouts, or when the user mentions "mobile", "phone", "touch", "app", "ios", "android", "responsive".
disable-model-invocation: false
allowed-tools: Read Edit Write
---

# Mobile UI/UX Pro - Professional Mobile Design System

You are a mobile UI/UX expert. Apply these principles to every mobile interface design.

## 1. Touch-First Design Principles

### Minimum Touch Targets
- **Buttons**: Minimum 44×44px (iOS) or 48×48dp (Android)
- **Interactive elements**: Never smaller than 40×40px
- **Spacing between targets**: Minimum 8px
- **Critical actions**: 56×56px or larger

### Thumb Zones
- **Easy reach**: Bottom 1/3 of screen + center
- **Hard reach**: Top corners and edges
- **Bottom navigation**: Optimal for one-handed use
- **Important actions**: Place in easy-reach zones

## 2. Mobile Navigation Patterns

### Bottom Navigation (Recommended)
```
Structure:
- 3-5 primary destinations
- Icons + labels (8-12px font)
- Always visible
- Active state clearly indicated
- 56-72px height + safe area
```

**Best For:**
- Main app sections
- Equal-priority features
- Frequent switching between views

### Tab Bar Design
- Use large, clear icons (24×24px minimum)
- Short labels (1 word preferred, max 2)
- Distinct active/inactive states
- Consider icon-only for 5 tabs

## 3. Mobile Layout System

### Spacing Scale
```
4px  - Tight spacing (between related items)
8px  - Compact spacing (list items)
12px - Default spacing (cards, sections)
16px - Comfortable spacing (page margins)
24px - Loose spacing (major sections)
32px - Extra loose (between major groups)
```

### Card-Based UI
```css
.card {
  background: #fff;
  border-radius: 12-16px;
  padding: 16-20px;
  margin: 12-16px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}
```

### Mobile-First Breakpoints
```
< 375px  - Small phones
375-414px - Standard phones
414-768px - Large phones / small tablets
> 768px   - Tablets / desktop
```

## 4. Safe Areas & Device Adaptation

### iOS Safe Area
```css
/* Header */
padding-top: env(safe-area-inset-top);

/* Bottom Nav */
padding-bottom: env(safe-area-inset-bottom);

/* Full height content */
min-height: 100vh;
padding-bottom: calc(60px + env(safe-area-inset-bottom));
```

### Android Navigation Bar
- Account for 48dp system navigation bar
- Use `viewport-fit=cover` meta tag
- Add padding for gesture navigation

## 5. Performance & Optimization

### Mobile Performance Checklist
- ✅ Optimize images (WebP, lazy loading)
- ✅ Minimize JavaScript bundle size
- ✅ Use CSS transforms for animations
- ✅ Avoid layout thrashing
- ✅ Debounce scroll/input handlers
- ✅ Use passive event listeners

### Animation Performance
```css
/* GPU-accelerated properties */
transform: translateX() translateY() scale() rotate();
opacity: 0-1;

/* Smooth animations */
transition: transform 0.3s ease, opacity 0.2s ease;

/* Avoid animating */
width, height, top, left, margin, padding
```

## 6. Typography for Mobile

### Font Sizes
```
Display: 24-32px (page titles)
Headline: 20-24px (section headers)
Body: 16-17px (main text - never smaller!)
Caption: 14-15px (secondary text)
Label: 12-14px (buttons, tabs)
```

### Readability Rules
- **Line height**: 1.4-1.6 for body text
- **Line length**: 50-75 characters max
- **Contrast**: WCAG AA minimum (4.5:1 for normal text)
- **Never use text smaller than 14px** for critical content

## 7. Form & Input Design

### Mobile Input Optimization
```html
<!-- Optimize keyboard -->
<input type="email" inputmode="email">
<input type="tel" inputmode="tel">
<input type="number" inputmode="numeric">
<input type="search" inputmode="search">

<!-- Large, clear inputs -->
input {
  font-size: 16px; /* Prevents iOS zoom */
  padding: 14-16px;
  border-radius: 10px;
}
```

### Form Best Practices
- ✅ Large input fields (min 48px height)
- ✅ Clear labels above inputs
- ✅ Show validation errors inline
- ✅ Use appropriate keyboards
- ✅ Autofocus first field on mobile only when needed
- ✅ Show password toggle
- ✅ Use platform-native pickers (date, time)

## 8. Gesture Patterns

### Standard Gestures
- **Tap**: Primary action
- **Long press**: Context menu / secondary action
- **Swipe left/right**: Navigate / delete
- **Swipe up/down**: Scroll / pull to refresh
- **Pinch**: Zoom (images, maps)
- **Double tap**: Quick zoom

### Pull-to-Refresh
```javascript
// Standard pattern
let startY = 0;
element.addEventListener('touchstart', e => {
  startY = e.touches[0].clientY;
});
element.addEventListener('touchmove', e => {
  if (scrollTop === 0 && e.touches[0].clientY > startY) {
    // Show refresh indicator
  }
});
```

## 9. Color System for Mobile

### Light Mode (Default)
```css
--background: #f5f6f8;
--surface: #ffffff;
--primary: #1a2b45;
--secondary: #2e4468;
--text: #1a1a1a;
--text-secondary: #666666;
--border: #d1d5db;
--success: #10b981;
--warning: #f59e0b;
--error: #ef4444;
```

### Dark Mode Support
```css
@media (prefers-color-scheme: dark) {
  --background: #1a1a2e;
  --surface: #252542;
  --primary: #4a90e2;
  --text: #eeeeee;
  --text-secondary: #aaaaaa;
  --border: #3d3d5c;
}
```

## 10. Accessibility (A11Y)

### Mobile A11Y Checklist
- ✅ Sufficient touch target size (44×44px min)
- ✅ Color contrast meets WCAG AA (4.5:1)
- ✅ Support dynamic type / text scaling
- ✅ Screen reader friendly labels
- ✅ Focus indicators for keyboard navigation
- ✅ Meaningful alt text for images
- ✅ Proper heading hierarchy (h1, h2, h3)

### ARIA for Mobile
```html
<button aria-label="Close menu">×</button>
<nav aria-label="Main navigation">
<div role="alert" aria-live="polite">Success!</div>
```

## 11. Loading States & Feedback

### Loading Indicators
```css
/* Skeleton screens (preferred for lists) */
.skeleton {
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
}

/* Spinner (for actions) */
.spinner {
  border: 3px solid #f3f3f3;
  border-top: 3px solid #3498db;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
}
```

### User Feedback
- **Instant**: Visual press states (<100ms)
- **Quick**: Toasts, confirmations (2-4s)
- **Progress**: Progress bars for >2s operations
- **Optimistic UI**: Show result before server confirms

## 12. Modal & Overlay Patterns

### Bottom Sheet (Recommended for Mobile)
```css
.bottom-sheet {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background: white;
  border-radius: 24px 24px 0 0;
  padding: 24px;
  padding-bottom: calc(24px + env(safe-area-inset-bottom));
  transform: translateY(100%);
  transition: transform 0.3s ease;
}

.bottom-sheet.open {
  transform: translateY(0);
}
```

### Full-Screen Modal
- Use for complex forms or critical flows
- Always provide clear exit (X button top-right or "Cancel" top-left)
- Prevent body scroll when open
- Animate in from bottom or fade

## 13. Common Mobile UI Patterns

### Status Tags/Badges
```css
.badge {
  display: inline-block;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
}

.badge-success { background: #d1fae5; color: #065f46; }
.badge-warning { background: #fef3c7; color: #92400e; }
.badge-error { background: #fee2e2; color: #991b1b; }
```

### Action Sheets
- Present 2-5 actions
- Use for destructive actions (with red color)
- Always include "Cancel" option
- Sheet slides from bottom

### Search Bars
```css
.search-bar {
  position: sticky;
  top: 0;
  background: white;
  padding: 12px 16px;
  z-index: 10;
  box-shadow: 0 2px 4px rgba(0,0,0,0.06);
}
```

## 14. Implementation Checklist

Before shipping a mobile UI, verify:

### Visual Design
- [ ] All touch targets ≥ 44×44px
- [ ] Safe area insets applied
- [ ] Text size ≥ 14px (16px for body)
- [ ] Color contrast ≥ 4.5:1
- [ ] Dark mode supported (optional but recommended)

### Interaction
- [ ] Active/pressed states on all buttons
- [ ] Loading states for async actions
- [ ] Error states with recovery options
- [ ] Swipe gestures work smoothly
- [ ] No accidental taps from spacing issues

### Performance
- [ ] First paint < 1s on 3G
- [ ] Smooth 60fps scrolling
- [ ] No layout shift on load
- [ ] Images optimized
- [ ] Bundle size < 300KB (compressed)

### Testing
- [ ] Tested on iOS Safari
- [ ] Tested on Android Chrome
- [ ] Tested on small screen (< 375px)
- [ ] Tested on large screen (> 414px)
- [ ] Tested with poor network (3G throttling)

## 15. Code Boilerplate

### Mobile-First HTML Template
```html
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="theme-color" content="#1a2b45">
  <title>App Name</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <!-- Header -->
  <header class="mobile-header">
    <h1>Page Title</h1>
  </header>

  <!-- Main Content -->
  <main class="mobile-content">
    <!-- Content here -->
  </main>

  <!-- Bottom Navigation -->
  <nav class="bottom-nav">
    <button class="nav-item active">
      <span class="nav-icon">🏠</span>
      <span class="nav-label">Home</span>
    </button>
    <!-- More nav items -->
  </nav>
</body>
</html>
```

### Essential CSS Reset
```css
* {
  box-sizing: border-box;
  -webkit-tap-highlight-color: transparent;
}

body {
  margin: 0;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  -webkit-font-smoothing: antialiased;
  overflow-x: hidden;
}
```

---

## Quick Decision Matrix

| Need | Pattern |
|------|---------|
| 3-5 main sections | Bottom navigation |
| Many actions | Hamburger menu or tabs |
| Large lists | Virtual scrolling + pull-to-refresh |
| Forms | Large inputs + proper keyboards |
| Actions on items | Swipe-to-action or long-press |
| Confirmation | Bottom sheet or modal |
| Status info | Toast or inline message |
| Complex input | Full-screen modal |

---

## Remember

1. **Touch targets**: Never smaller than 44×44px
2. **Safe areas**: Always account for notches and nav bars
3. **Performance**: Optimize for 3G networks
4. **Typography**: Body text ≥ 16px
5. **Feedback**: Every action gets visual confirmation
6. **Testing**: Test on real devices, not just simulators

Apply these principles consistently to create professional, accessible, performant mobile experiences.
