# CIRO Web UI - React Dashboard & Monitoring

Modern web interface for CIRO crisis management system, built with React, TypeScript, and Vite for fast development and production builds.

## Overview

The web UI provides:
- **Crisis Dashboard**: Real-time map of active crises
- **Signal Feed**: Historical signals and alerts
- **Dispatch Center**: Command & control for response coordination
- **Analytics**: Historical trends and response metrics
- **Admin Panel**: System configuration and user management

## Tech Stack

- **Frontend Framework**: React 18+
- **Language**: TypeScript 5+
- **Build Tool**: Vite (ESM bundler, <1s HMR)
- **Styling**: PostCSS + custom design system
- **Component Library**: shadcn/ui patterns
- **Package Manager**: PNPM (fast, efficient)
- **Monorepo**: PNPM workspaces for shared utilities

## Project Structure

```
Ui/
├── src/
│   ├── main.tsx           # React entry point
│   ├── app/               # Feature components
│   │   ├── Dashboard.tsx  # Crisis dashboard
│   │   ├── Dispatch.tsx   # Dispatch center
│   │   └── Analytics.tsx  # Metrics & trends
│   ├── components/        # Reusable UI components
│   │   ├── CrisisCard.tsx
│   │   ├── Map.tsx
│   │   └── ...
│   ├── hooks/            # Custom React hooks
│   │   ├── useFirestore.ts
│   │   └── useGeolocation.ts
│   ├── types/            # TypeScript interfaces
│   │   └── crisis.ts
│   ├── styles/           # Global & component-scoped styles
│   │   └── theme.css
│   └── utils/            # Helpers
│       ├── firebase.ts
│       └── formatting.ts
├── public/               # Static assets
├── vite.config.ts        # Vite build configuration
├── tsconfig.json         # TypeScript configuration
├── package.json          # Dependencies & scripts
└── pnpm-workspace.yaml   # Monorepo workspaces (optional)
```

## Getting Started

### Prerequisites
- Node.js 16+ (18+ recommended)
- PNPM 7+
- Firebase project with Firestore enabled

### Installation

```bash
# Install dependencies
pnpm install

# Start development server (http://localhost:5173)
pnpm run dev

# Build for production
pnpm run build

# Preview production build
pnpm run preview

# Type checking
pnpm run type-check

# Lint code
pnpm run lint
```

## Development

### Hot Module Replacement (HMR)
Changes to React components, styles, and utilities are instantly reflected in the browser without full page reload.

```bash
pnpm run dev
# Edit src/app/Dashboard.tsx → changes visible in <1s
```

### Adding New Pages

1. Create component in `src/app/`:
```tsx
// src/app/Reports.tsx
export function Reports() {
  return <div>Reports Page</div>;
}
```

2. Add route in `src/main.tsx`:
```tsx
import { Reports } from './app/Reports';

<Router>
  <Route path="/reports" element={<Reports />} />
</Router>
```

### Adding Components

Use the shadcn/ui pattern for consistency:

```tsx
// src/components/CrisisAlert.tsx
interface CrisisAlertProps {
  crisis: Crisis;
  onDismiss: () => void;
}

export function CrisisAlert({ crisis, onDismiss }: CrisisAlertProps) {
  return (
    <div className="alert alert-danger">
      <h3>{crisis.title}</h3>
      <button onClick={onDismiss}>Dismiss</button>
    </div>
  );
}
```

## Firebase Integration

The app connects to Firestore for real-time crisis data:

```tsx
// src/hooks/useFirestore.ts
import { collection, onSnapshot } from 'firebase/firestore';
import { db } from '../utils/firebase';

export function useCrises() {
  const [crises, setCrises] = useState<Crisis[]>([]);

  useEffect(() => {
    const unsubscribe = onSnapshot(
      collection(db, 'crises'),
      (snapshot) => {
        setCrises(snapshot.docs.map(doc => doc.data()));
      }
    );

    return () => unsubscribe();
  }, []);

  return crises;
}
```

## Building for Production

```bash
# Create optimized bundle
pnpm run build

# Output: dist/
# - Minified JavaScript
# - Optimized images
# - CSS modules combined
# - Ready to deploy to CDN or static hosting
```

### Deploy to Vercel
```bash
# Already configured for zero-config deployment
npm i -g vercel
vercel
```

### Deploy to GitHub Pages
```bash
# Update vite.config.ts
base: '/CIRO/'

# Run build
pnpm run build

# Push dist/ to gh-pages branch
git subtree push --prefix dist origin gh-pages
```

## Styling

Global styles are in `src/styles/theme.css`. Component scoping uses CSS modules or inline styles:

```tsx
import styles from './CrisisCard.module.css';

export function CrisisCard() {
  return <div className={styles.card}>Content</div>;
}
```

### Customizing Theme

Edit `src/styles/theme.css`:
```css
:root {
  --color-primary: #1e3a8a;
  --color-danger: #dc2626;
  --spacing-base: 1rem;
}
```

## Performance Tips

- Use React code splitting for large pages:
```tsx
const Dashboard = lazy(() => import('./app/Dashboard'));
```

- Memoize expensive computations:
```tsx
const memoizedCrises = useMemo(
  () => crises.sort((a, b) => b.severity - a.severity),
  [crises]
);
```

- Avoid re-renders with proper React keys:
```tsx
crises.map(crisis => <CrisisCard key={crisis.id} crisis={crisis} />)
```

## Testing

```bash
# Unit tests (Vitest)
pnpm run test

# Coverage report
pnpm run test:coverage

# E2E tests (Cypress)
pnpm run test:e2e
```

## Known Issues

- [ ] Real-time markers on map occasionally lag (consider WebSocket upgrade)
- [ ] First load time could be reduced with code splitting
- [ ] Mobile responsiveness needs refinement for small screens

## Contributing

1. Create a feature branch: `git checkout -b feature/new-page`
2. Make changes following existing patterns
3. Run type check: `pnpm run type-check`
4. Commit: `git commit -m "feat: add trends analytics page"`
5. Push and create Pull Request

## Troubleshooting

### Build fails with "Module not found"
- Run `pnpm install` to ensure all dependencies are installed
- Check imports use correct paths (no `.js` extensions in TypeScript)

### Firestore connection fails
- Verify `src/utils/firebase.ts` has correct project ID
- Check firestore.rules allow your domain

### Vite dev server not starting
- Kill any process on port 5173: `lsof -i :5173`
- Delete `node_modules/.vite` and restart

## Resources

- [React Docs](https://react.dev)
- [Vite Guide](https://vitejs.dev)
- [Firebase Web SDK](https://firebase.google.com/docs/web)
- [TypeScript Handbook](https://www.typescriptlang.org/docs)

---

**Last Updated**: May 2026  
**Maintained By**: Daniyal Jamil
