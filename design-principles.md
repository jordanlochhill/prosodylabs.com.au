# PROSODY LABS DESIGN PRINCIPLES
## Comprehensive UI/UX Design System & Technical Implementation Guide

**Purpose**: Establish consistent design principles and technical implementation standards to ensure cohesive, maintainable, and scalable user experience across all digital touchpoints.

**Scope**: All website components, layouts, interactions, and future digital products.

---

## 🎨 CORE DESIGN PHILOSOPHY

### **"Sophisticated Simplicity"**
Every design decision must serve both aesthetic and functional purposes, reflecting the precision and clarity that Prosody Labs brings to AI implementation. We communicate deep technical expertise through clean, accessible presentation.

### **Fundamental Principles**
1. **Clarity Over Complexity**: Simple, clear communication of complex concepts
2. **Function Drives Form**: Every visual element serves a specific user need
3. **Consistent Excellence**: Systematic approach to all design decisions
4. **Accessible by Design**: Inclusive design from the ground up
5. **Performance First**: Beautiful design that loads fast and works everywhere

---

## 🏗️ TECHNICAL ARCHITECTURE PRINCIPLES

### **1. CSS Architecture Standards**

#### **SCSS-Only Approach** ✅
```scss
// ✅ CORRECT: Centralized, maintainable styling
.collection-card {
  background: var(--color-neutral-0);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  transition: var(--transition-base);
  
  &:hover {
    box-shadow: var(--shadow-lg);
    transform: translateY(-2px);
  }
}
```

#### **Forbidden Practices** ❌
```html
<!-- ❌ NEVER: Inline styles -->
<div style="background: white; padding: 20px;">

<!-- ❌ NEVER: Style blocks in HTML -->
<style>
  .my-component { color: red; }
</style>
```

#### **Architecture Requirements**:
- **All styles** must be defined in SCSS files within the `_sass/` directory
- **Design tokens** must be used instead of hardcoded values
- **Component-based** organization with clear file structure
- **Mobile-first** responsive design patterns
- **BEM methodology** for CSS class naming when appropriate

### **2. Design Token System**

#### **Color System**
```scss
// Primary Brand Colors
:root {
  --color-primary-50:   #eff6ff;
  --color-primary-100:  #dbeafe;
  --color-primary-200:  #bfdbfe;
  --color-primary-300:  #93c5fd;
  --color-primary-400:  #60a5fa;
  --color-primary-500:  #3b82f6;  // Main brand
  --color-primary-600:  #2563eb;
  --color-primary-700:  #1d4ed8;
  --color-primary-800:  #1e40af;
  --color-primary-900:  #1e3a8a;
  
  // Neutral Scale
  --color-neutral-0:    #ffffff;
  --color-neutral-50:   #f9fafb;
  --color-neutral-100:  #f3f4f6;
  --color-neutral-200:  #e5e7eb;
  --color-neutral-300:  #d1d5db;
  --color-neutral-400:  #9ca3af;
  --color-neutral-500:  #6b7280;
  --color-neutral-600:  #4b5563;
  --color-neutral-700:  #374151;
  --color-neutral-800:  #1f2937;
  --color-neutral-900:  #111827;
  
  // Semantic Colors
  --color-success:      #10b981;
  --color-warning:      #f59e0b;
  --color-error:        #ef4444;
  --color-info:         #3b82f6;
}
```

#### **Typography Scale**
```scss
:root {
  // Font Families
  --font-primary:       'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
  --font-serif:         'Merriweather', Georgia, serif;
  --font-mono:          'JetBrains Mono', 'Fira Code', monospace;
  
  // Font Sizes (Modular Scale: 1.250 - Major Third)
  --text-xs:            0.75rem;    // 12px
  --text-sm:            0.875rem;   // 14px
  --text-base:          1rem;       // 16px
  --text-lg:            1.125rem;   // 18px
  --text-xl:            1.25rem;    // 20px
  --text-2xl:           1.5rem;     // 24px
  --text-3xl:           1.875rem;   // 30px
  --text-4xl:           2.25rem;    // 36px
  --text-5xl:           3rem;       // 48px
  --text-6xl:           3.75rem;    // 60px
  
  // Font Weights
  --font-light:         300;
  --font-normal:        400;
  --font-medium:        500;
  --font-semibold:      600;
  --font-bold:          700;
  
  // Line Heights
  --leading-tight:      1.25;
  --leading-snug:       1.375;
  --leading-normal:     1.5;
  --leading-relaxed:    1.625;
  --leading-loose:      2;
}
```

#### **Spacing System (8px Base Unit)**
```scss
:root {
  --space-0:            0;
  --space-px:           1px;
  --space-0-5:          0.125rem;   // 2px
  --space-1:            0.25rem;    // 4px
  --space-1-5:          0.375rem;   // 6px
  --space-2:            0.5rem;     // 8px
  --space-2-5:          0.625rem;   // 10px
  --space-3:            0.75rem;    // 12px
  --space-3-5:          0.875rem;   // 14px
  --space-4:            1rem;       // 16px
  --space-5:            1.25rem;    // 20px
  --space-6:            1.5rem;     // 24px
  --space-7:            1.75rem;    // 28px
  --space-8:            2rem;       // 32px
  --space-9:            2.25rem;    // 36px
  --space-10:           2.5rem;     // 40px
  --space-11:           2.75rem;    // 44px
  --space-12:           3rem;       // 48px
  --space-14:           3.5rem;     // 56px
  --space-16:           4rem;       // 64px
  --space-20:           5rem;       // 80px
  --space-24:           6rem;       // 96px
  --space-28:           7rem;       // 112px
  --space-32:           8rem;       // 128px
}
```

#### **Border Radius System**
```scss
:root {
  --radius-none:        0;
  --radius-sm:          0.125rem;   // 2px
  --radius-base:        0.25rem;    // 4px
  --radius-md:          0.375rem;   // 6px
  --radius-lg:          0.5rem;     // 8px
  --radius-xl:          0.75rem;    // 12px
  --radius-2xl:         1rem;       // 16px
  --radius-3xl:         1.5rem;     // 24px
  --radius-full:        9999px;
}
```

#### **Shadow System**
```scss
:root {
  --shadow-sm:          0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-base:        0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
  --shadow-md:          0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  --shadow-lg:          0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  --shadow-xl:          0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  --shadow-2xl:         0 25px 50px -12px rgba(0, 0, 0, 0.25);
  --shadow-inner:       inset 0 2px 4px 0 rgba(0, 0, 0, 0.06);
}
```

#### **Animation & Transition System**
```scss
:root {
  // Durations
  --duration-75:        75ms;
  --duration-100:       100ms;
  --duration-150:       150ms;
  --duration-200:       200ms;
  --duration-300:       300ms;
  --duration-500:       500ms;
  --duration-700:       700ms;
  --duration-1000:      1000ms;
  
  // Easing Functions
  --ease-linear:        linear;
  --ease-in:            cubic-bezier(0.4, 0, 1, 1);
  --ease-out:           cubic-bezier(0, 0, 0.2, 1);
  --ease-in-out:        cubic-bezier(0.4, 0, 0.2, 1);
  
  // Common Transitions
  --transition-base:    all var(--duration-150) var(--ease-out);
  --transition-colors:  color var(--duration-150) var(--ease-out), 
                       background-color var(--duration-150) var(--ease-out), 
                       border-color var(--duration-150) var(--ease-out);
  --transition-opacity: opacity var(--duration-150) var(--ease-out);
  --transition-shadow:  box-shadow var(--duration-150) var(--ease-out);
  --transition-transform: transform var(--duration-150) var(--ease-out);
}
```

### **3. Responsive Design Standards**

#### **Breakpoint System**
```scss
// Mobile-first breakpoints
:root {
  --breakpoint-sm:      640px;   // Small devices
  --breakpoint-md:      768px;   // Medium devices
  --breakpoint-lg:      1024px;  // Large devices
  --breakpoint-xl:      1280px;  // Extra large devices
  --breakpoint-2xl:     1536px;  // 2X large devices
}

// Mixins for responsive design
@mixin respond-above($breakpoint) {
  @media screen and (min-width: $breakpoint) {
    @content;
  }
}

@mixin respond-below($breakpoint) {
  @media screen and (max-width: $breakpoint - 1px) {
    @content;
  }
}

@mixin respond-between($min, $max) {
  @media screen and (min-width: $min) and (max-width: $max - 1px) {
    @content;
  }
}
```

#### **Container System**
```scss
.container {
  width: 100%;
  margin-left: auto;
  margin-right: auto;
  padding-left: var(--space-4);
  padding-right: var(--space-4);
  
  @include respond-above(640px) {
    max-width: 640px;
  }
  
  @include respond-above(768px) {
    max-width: 768px;
  }
  
  @include respond-above(1024px) {
    max-width: 1024px;
  }
  
  @include respond-above(1280px) {
    max-width: 1280px;
  }
  
  @include respond-above(1536px) {
    max-width: 1536px;
  }
}
```

---

## 🎯 COMPONENT DESIGN PRINCIPLES

### **1. Button System**

#### **Design Requirements**:
- **Minimum touch target**: 44px × 44px (WCAG AA compliance)
- **Clear visual hierarchy**: Primary, secondary, tertiary states
- **Consistent spacing**: Internal padding using design tokens
- **Accessible states**: Focus, hover, active, disabled
- **Loading states**: For async operations

#### **Implementation Example**:
```scss
.btn {
  // Base styles
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 44px;
  padding: var(--space-3) var(--space-6);
  font-family: var(--font-primary);
  font-weight: var(--font-medium);
  font-size: var(--text-base);
  line-height: var(--leading-normal);
  border-radius: var(--radius-lg);
  border: 1px solid transparent;
  cursor: pointer;
  transition: var(--transition-colors), var(--transition-shadow);
  text-decoration: none;
  
  // Focus state (accessibility)
  &:focus-visible {
    outline: 2px solid var(--color-primary-500);
    outline-offset: 2px;
  }
  
  // Disabled state
  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
    pointer-events: none;
  }
  
  // Primary variant
  &--primary {
    background-color: var(--color-primary-500);
    color: var(--color-neutral-0);
    
    &:hover:not(:disabled) {
      background-color: var(--color-primary-600);
      box-shadow: var(--shadow-md);
    }
    
    &:active:not(:disabled) {
      background-color: var(--color-primary-700);
    }
  }
  
  // Secondary variant
  &--secondary {
    background-color: transparent;
    color: var(--color-primary-500);
    border-color: var(--color-primary-500);
    
    &:hover:not(:disabled) {
      background-color: var(--color-primary-50);
    }
  }
}
```

### **2. Card System**

#### **Design Requirements**:
- **Consistent elevation**: Using shadow system
- **Proper spacing**: Internal padding using design tokens
- **Hover states**: Subtle elevation changes
- **Content hierarchy**: Clear visual organization
- **Responsive behavior**: Adapts to container width

#### **Implementation Example**:
```scss
.card {
  background-color: var(--color-neutral-0);
  border-radius: var(--radius-2xl);
  box-shadow: var(--shadow-base);
  padding: var(--space-6);
  transition: var(--transition-shadow), var(--transition-transform);
  
  &:hover {
    box-shadow: var(--shadow-lg);
    transform: translateY(-2px);
  }
  
  &__header {
    margin-bottom: var(--space-4);
  }
  
  &__title {
    font-size: var(--text-xl);
    font-weight: var(--font-semibold);
    color: var(--color-neutral-900);
    margin-bottom: var(--space-2);
  }
  
  &__content {
    color: var(--color-neutral-600);
    line-height: var(--leading-relaxed);
  }
}
```

### **3. Typography System**

#### **Heading Hierarchy**:
```scss
h1, .heading-1 {
  font-size: var(--text-4xl);
  font-weight: var(--font-bold);
  line-height: var(--leading-tight);
  color: var(--color-neutral-900);
  
  @include respond-above(768px) {
    font-size: var(--text-5xl);
  }
}

h2, .heading-2 {
  font-size: var(--text-3xl);
  font-weight: var(--font-semibold);
  line-height: var(--leading-tight);
  color: var(--color-neutral-900);
  
  @include respond-above(768px) {
    font-size: var(--text-4xl);
  }
}

h3, .heading-3 {
  font-size: var(--text-2xl);
  font-weight: var(--font-semibold);
  line-height: var(--leading-snug);
  color: var(--color-neutral-900);
  
  @include respond-above(768px) {
    font-size: var(--text-3xl);
  }
}
```

#### **Body Text Standards**:
```scss
.text-body {
  font-size: var(--text-base);
  line-height: var(--leading-relaxed);
  color: var(--color-neutral-700);
  
  @include respond-above(768px) {
    font-size: var(--text-lg);
  }
}

.text-small {
  font-size: var(--text-sm);
  line-height: var(--leading-normal);
  color: var(--color-neutral-600);
}
```

---

## 🔧 LAYOUT PRINCIPLES

### **1. Grid System**

#### **CSS Grid Approach** (Preferred)
```scss
.grid {
  display: grid;
  gap: var(--space-6);
  
  &--cols-1 { grid-template-columns: 1fr; }
  &--cols-2 { grid-template-columns: repeat(2, 1fr); }
  &--cols-3 { grid-template-columns: repeat(3, 1fr); }
  &--cols-4 { grid-template-columns: repeat(4, 1fr); }
  
  // Responsive variants
  @include respond-above(768px) {
    &--md-cols-2 { grid-template-columns: repeat(2, 1fr); }
    &--md-cols-3 { grid-template-columns: repeat(3, 1fr); }
  }
  
  @include respond-above(1024px) {
    &--lg-cols-3 { grid-template-columns: repeat(3, 1fr); }
    &--lg-cols-4 { grid-template-columns: repeat(4, 1fr); }
  }
}
```

#### **Flexbox for Components**
```scss
.flex {
  display: flex;
  
  &--col { flex-direction: column; }
  &--row { flex-direction: row; }
  &--wrap { flex-wrap: wrap; }
  &--center { justify-content: center; }
  &--between { justify-content: space-between; }
  &--items-center { align-items: center; }
  &--items-start { align-items: flex-start; }
}
```

### **2. Spacing System Usage**

#### **Consistent Spacing Rules**:
- **Section spacing**: Use `--space-16` to `--space-32` for major sections
- **Component spacing**: Use `--space-4` to `--space-12` for component internal spacing
- **Element spacing**: Use `--space-1` to `--space-6` for small element spacing
- **Typography spacing**: Use `--space-2` to `--space-8` for text element margins

```scss
.section {
  padding-top: var(--space-16);
  padding-bottom: var(--space-16);
  
  @include respond-above(768px) {
    padding-top: var(--space-24);
    padding-bottom: var(--space-24);
  }
}

.component {
  margin-bottom: var(--space-8);
  padding: var(--space-6);
}
```

---

## ♿ ACCESSIBILITY PRINCIPLES

### **1. Color and Contrast**

#### **Contrast Requirements**:
- **Normal text**: Minimum 4.5:1 contrast ratio
- **Large text**: Minimum 3:1 contrast ratio
- **Non-text elements**: Minimum 3:1 contrast ratio
- **Focus indicators**: Clearly visible and high contrast

#### **Color Usage Rules**:
```scss
// ✅ CORRECT: High contrast combinations
.text-primary { color: var(--color-neutral-900); }  // Black on white: 21:1
.text-secondary { color: var(--color-neutral-700); } // Dark gray: 4.5:1+
.link-primary { color: var(--color-primary-600); }   // Blue: 4.5:1+

// ❌ AVOID: Low contrast combinations
.text-light { color: var(--color-neutral-400); }     // Light gray: 2.8:1
```

### **2. Focus Management**

#### **Focus Indicators**:
```scss
:focus-visible {
  outline: 2px solid var(--color-primary-500);
  outline-offset: 2px;
  border-radius: var(--radius-base);
}

// Remove default focus for mouse users
:focus:not(:focus-visible) {
  outline: none;
}
```

#### **Skip Links**:
```scss
.skip-link {
  position: absolute;
  top: -40px;
  left: 6px;
  background: var(--color-neutral-900);
  color: var(--color-neutral-0);
  padding: var(--space-2) var(--space-4);
  border-radius: var(--radius-base);
  text-decoration: none;
  z-index: 9999;
  
  &:focus {
    top: 6px;
  }
}
```

### **3. Motion and Animation**

#### **Reduced Motion Support**:
```scss
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

---

## 📱 MOBILE-FIRST PRINCIPLES

### **1. Touch Target Guidelines**

#### **Minimum Sizes**:
- **Interactive elements**: 44px × 44px minimum
- **Spacing between targets**: 8px minimum
- **Thumb-friendly zones**: Bottom 1/3 of screen for primary actions

### **2. Progressive Enhancement**

#### **Mobile-First CSS Structure**:
```scss
// Base styles (mobile)
.component {
  padding: var(--space-4);
  font-size: var(--text-base);
}

// Enhanced for larger screens
@include respond-above(768px) {
  .component {
    padding: var(--space-6);
    font-size: var(--text-lg);
  }
}

@include respond-above(1024px) {
  .component {
    padding: var(--space-8);
  }
}
```

---

## 🚀 PERFORMANCE PRINCIPLES

### **1. CSS Optimization**

#### **Critical CSS Strategy**:
- **Above-the-fold styles**: Inline critical CSS for initial render
- **Non-critical styles**: Load asynchronously
- **Component styles**: Load only when components are used

#### **File Organization**:
```scss
// main.scss - Import order for optimal performance
@import 'variables';      // Design tokens first
@import 'mixins';         // Utilities second
@import 'base';           // Reset and base styles
@import 'layout';         // Layout components
@import 'components';     // UI components
@import 'utilities';      // Utility classes last
```

### **2. Asset Optimization**

#### **Image Guidelines**:
- **WebP format**: Primary format with fallbacks
- **Responsive images**: Multiple sizes for different viewports
- **Lazy loading**: For below-the-fold images
- **Alt text**: Required for all images

---

## 📋 IMPLEMENTATION CHECKLIST

### **Before Adding New Components**:
- [ ] Uses design tokens instead of hardcoded values
- [ ] Follows mobile-first responsive approach
- [ ] Meets accessibility contrast requirements
- [ ] Includes focus states for interactive elements
- [ ] Has hover states where appropriate
- [ ] Uses semantic HTML structure
- [ ] Includes loading/disabled states if applicable
- [ ] Tested across different screen sizes
- [ ] Validated with screen reader

### **Code Review Requirements**:
- [ ] No inline styles or style blocks
- [ ] Consistent naming conventions
- [ ] Proper SCSS nesting (max 3 levels)
- [ ] Uses design system variables
- [ ] Includes responsive considerations
- [ ] Accessible markup and styling
- [ ] Performance optimizations applied

---

## 🔄 MAINTENANCE & EVOLUTION

### **Design System Updates**:
1. **Token Updates**: Changes to design tokens cascade throughout system
2. **Component Evolution**: New variants added systematically
3. **Documentation**: All changes documented with examples
4. **Testing**: Visual regression testing for major updates
5. **Migration Guides**: Clear upgrade paths for breaking changes

### **Quality Assurance**:
- **Automated Testing**: CSS linting and validation
- **Visual Testing**: Screenshot comparisons across browsers
- **Accessibility Testing**: Automated and manual accessibility audits
- **Performance Monitoring**: CSS bundle size and load time tracking

---

**Last Updated**: [Current Date]  
**Version**: 1.0  
**Next Review**: After Phase 1 Implementation  
**Maintainer**: Development Team  

**Quick Reference**: See `css/main.scss` for complete design token implementation 