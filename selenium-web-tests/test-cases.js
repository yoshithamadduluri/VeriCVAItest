// ─── VeriCV AI Selenium Web Test Cases (120 Total, 12 Categories) ───

const WEB_TEST_CASES = [
  // ── 1. Page Load & Rendering (1-10) ──
  { id: 'STC001', category: 'Page Load & Rendering', description: 'Verify app loads and Flutter engine initialises within 5 seconds' },
  { id: 'STC002', category: 'Page Load & Rendering', description: 'Verify page title is "vericvai" in browser tab' },
  { id: 'STC003', category: 'Page Load & Rendering', description: 'Verify favicon.png loads successfully' },
  { id: 'STC004', category: 'Page Load & Rendering', description: 'Verify Flutter canvas element is rendered in DOM' },
  { id: 'STC005', category: 'Page Load & Rendering', description: 'Verify no JavaScript console errors on initial load' },
  { id: 'STC006', category: 'Page Load & Rendering', description: 'Verify HTML meta charset is UTF-8' },
  { id: 'STC007', category: 'Page Load & Rendering', description: 'Verify manifest.json loads with correct app name' },
  { id: 'STC008', category: 'Page Load & Rendering', description: 'Verify flutter_bootstrap.js script tag exists in DOM' },
  { id: 'STC009', category: 'Page Load & Rendering', description: 'Verify Google Sign-In meta client_id is present in head' },
  { id: 'STC010', category: 'Page Load & Rendering', description: 'Verify responsive viewport meta tag is configured' },

  // ── 2. Authentication – Login (11-20) ──
  { id: 'STC011', category: 'Authentication - Login', description: 'Verify Login screen renders after app loads' },
  { id: 'STC012', category: 'Authentication - Login', description: 'Verify VeriCV AI headline text appears on login screen' },
  { id: 'STC013', category: 'Authentication - Login', description: 'Verify document_scanner icon renders with correct color' },
  { id: 'STC014', category: 'Authentication - Login', description: 'Verify Email input field is accessible and focusable' },
  { id: 'STC015', category: 'Authentication - Login', description: 'Verify Password input field renders with obscure text enabled' },
  { id: 'STC016', category: 'Authentication - Login', description: 'Verify Login button is clickable and triggers loading state' },
  { id: 'STC017', category: 'Authentication - Login', description: 'Verify empty email/password shows error snackbar' },
  { id: 'STC018', category: 'Authentication - Login', description: 'Verify invalid credentials display parsed error message' },
  { id: 'STC019', category: 'Authentication - Login', description: 'Verify Sign in with Google button renders with G icon' },
  { id: 'STC020', category: 'Authentication - Login', description: 'Verify "Don\'t have an account? Sign Up" link navigates to signup' },

  // ── 3. Authentication – Signup (21-30) ──
  { id: 'STC021', category: 'Authentication - Signup', description: 'Verify Signup screen renders after clicking Sign Up link' },
  { id: 'STC022', category: 'Authentication - Signup', description: 'Verify Full Name input field is present and focusable' },
  { id: 'STC023', category: 'Authentication - Signup', description: 'Verify Email field on signup screen accepts email format' },
  { id: 'STC024', category: 'Authentication - Signup', description: 'Verify Password field on signup screen obscures text' },
  { id: 'STC025', category: 'Authentication - Signup', description: 'Verify Confirm Password field validates match with password' },
  { id: 'STC026', category: 'Authentication - Signup', description: 'Verify Create Account button exists and is interactive' },
  { id: 'STC027', category: 'Authentication - Signup', description: 'Verify signup with mismatched passwords shows validation error' },
  { id: 'STC028', category: 'Authentication - Signup', description: 'Verify weak password (< 6 chars) is rejected with error message' },
  { id: 'STC029', category: 'Authentication - Signup', description: 'Verify signup with existing email shows "already in use" error' },
  { id: 'STC030', category: 'Authentication - Signup', description: 'Verify "Already have an account? Login" link navigates back' },

  // ── 4. Dashboard Screen (31-40) ──
  { id: 'STC031', category: 'Dashboard Screen', description: 'Verify Dashboard screen renders after successful authentication' },
  { id: 'STC032', category: 'Dashboard Screen', description: 'Verify user display name appears in dashboard header' },
  { id: 'STC033', category: 'Dashboard Screen', description: 'Verify Trust Score widget renders with numerical value' },
  { id: 'STC034', category: 'Dashboard Screen', description: 'Verify Resume Analysis summary card is visible' },
  { id: 'STC035', category: 'Dashboard Screen', description: 'Verify Quick Actions section is rendered on dashboard' },
  { id: 'STC036', category: 'Dashboard Screen', description: 'Verify bottom navigation bar has 4 tabs' },
  { id: 'STC037', category: 'Dashboard Screen', description: 'Verify clicking Resume tab navigates to Resume Upload screen' },
  { id: 'STC038', category: 'Dashboard Screen', description: 'Verify clicking Interview tab navigates to Mock Interview screen' },
  { id: 'STC039', category: 'Dashboard Screen', description: 'Verify clicking Profile tab navigates to Profile screen' },
  { id: 'STC040', category: 'Dashboard Screen', description: 'Verify app bar title displays "VeriCV AI Dashboard"' },

  // ── 5. Resume Upload Screen (41-50) ──
  { id: 'STC041', category: 'Resume Upload Screen', description: 'Verify Resume Upload screen loads with upload button' },
  { id: 'STC042', category: 'Resume Upload Screen', description: 'Verify file picker button is visible and accessible' },
  { id: 'STC043', category: 'Resume Upload Screen', description: 'Verify upload area shows accepted file types (PDF, DOCX)' },
  { id: 'STC044', category: 'Resume Upload Screen', description: 'Verify ATS score breakdown section renders correctly' },
  { id: 'STC045', category: 'Resume Upload Screen', description: 'Verify keyword match percentage widget is displayed' },
  { id: 'STC046', category: 'Resume Upload Screen', description: 'Verify AI feedback section has structured recommendation cards' },
  { id: 'STC047', category: 'Resume Upload Screen', description: 'Verify upload progress indicator renders during file processing' },
  { id: 'STC048', category: 'Resume Upload Screen', description: 'Verify error handling for invalid file type (e.g., PNG upload)' },
  { id: 'STC049', category: 'Resume Upload Screen', description: 'Verify Job Match screen tab is accessible from resume module' },
  { id: 'STC050', category: 'Resume Upload Screen', description: 'Verify job description input field renders on job match screen' },

  // ── 6. Mock Interview Screen (51-60) ──
  { id: 'STC051', category: 'Mock Interview Screen', description: 'Verify Mock Interview screen renders with role input field' },
  { id: 'STC052', category: 'Mock Interview Screen', description: 'Verify job role text field accepts input and triggers question generation' },
  { id: 'STC053', category: 'Mock Interview Screen', description: 'Verify Start Interview button is present and active' },
  { id: 'STC054', category: 'Mock Interview Screen', description: 'Verify question card renders after Gemini AI generates question' },
  { id: 'STC055', category: 'Mock Interview Screen', description: 'Verify answer text input area is scrollable and multi-line' },
  { id: 'STC056', category: 'Mock Interview Screen', description: 'Verify Submit Answer button triggers scoring request' },
  { id: 'STC057', category: 'Mock Interview Screen', description: 'Verify score result displays after answer evaluation' },
  { id: 'STC058', category: 'Mock Interview Screen', description: 'Verify feedback text appears below score with improvement tips' },
  { id: 'STC059', category: 'Mock Interview Screen', description: 'Verify Next Question button cycles to a new question' },
  { id: 'STC060', category: 'Mock Interview Screen', description: 'Verify empty answer submission is rejected with validation message' },

  // ── 7. Profile Screen (61-70) ──
  { id: 'STC061', category: 'Profile Screen', description: 'Verify Profile screen renders with user information sections' },
  { id: 'STC062', category: 'Profile Screen', description: 'Verify user email is displayed correctly in profile' },
  { id: 'STC063', category: 'Profile Screen', description: 'Verify user full name is displayed and editable' },
  { id: 'STC064', category: 'Profile Screen', description: 'Verify GitHub integration link field is present' },
  { id: 'STC065', category: 'Profile Screen', description: 'Verify profile avatar or icon renders without error' },
  { id: 'STC066', category: 'Profile Screen', description: 'Verify Save Profile button triggers Firestore update' },
  { id: 'STC067', category: 'Profile Screen', description: 'Verify Logout button is visible and accessible' },
  { id: 'STC068', category: 'Profile Screen', description: 'Verify logout confirmation dialog appears before signing out' },
  { id: 'STC069', category: 'Profile Screen', description: 'Verify confirming logout redirects user to Login screen' },
  { id: 'STC070', category: 'Profile Screen', description: 'Verify canceling logout dialog keeps user on Profile screen' },

  // ── 8. UI & Visual Regression (71-80) ──
  { id: 'STC071', category: 'UI & Visual Regression', description: 'Verify primary theme color #6200EE is applied to main CTA buttons' },
  { id: 'STC072', category: 'UI & Visual Regression', description: 'Verify Material 3 card elevation shadows render on dashboard cards' },
  { id: 'STC073', category: 'UI & Visual Regression', description: 'Verify loading CircularProgressIndicator is visible during async calls' },
  { id: 'STC074', category: 'UI & Visual Regression', description: 'Verify snackbar floating notification renders above bottom nav' },
  { id: 'STC075', category: 'UI & Visual Regression', description: 'Verify error snackbar has red background (#C62828)' },
  { id: 'STC076', category: 'UI & Visual Regression', description: 'Verify success snackbar has green background' },
  { id: 'STC077', category: 'UI & Visual Regression', description: 'Verify all screen transitions use smooth Material page routes' },
  { id: 'STC078', category: 'UI & Visual Regression', description: 'Verify text contrast ratio meets WCAG AA standard (4.5:1)' },
  { id: 'STC079', category: 'UI & Visual Regression', description: 'Verify icon assets render without distortion at 1x and 2x scale' },
  { id: 'STC080', category: 'UI & Visual Regression', description: 'Verify app footer/copyright text renders if present' },

  // ── 9. Navigation & Routing (81-90) ──
  { id: 'STC081', category: 'Navigation & Routing', description: 'Verify browser back button navigates to previous screen' },
  { id: 'STC082', category: 'Navigation & Routing', description: 'Verify deep link to /dashboard routes authenticated user correctly' },
  { id: 'STC083', category: 'Navigation & Routing', description: 'Verify unauthenticated user accessing /dashboard is redirected to login' },
  { id: 'STC084', category: 'Navigation & Routing', description: 'Verify bottom navigation preserves state between tab switches' },
  { id: 'STC085', category: 'Navigation & Routing', description: 'Verify page title updates dynamically on each screen transition' },
  { id: 'STC086', category: 'Navigation & Routing', description: 'Verify double back press on root screen does not crash app' },
  { id: 'STC087', category: 'Navigation & Routing', description: 'Verify breadcrumb trail is consistent across nested screens' },
  { id: 'STC088', category: 'Navigation & Routing', description: 'Verify refresh of current page reloads Flutter app without blank screen' },
  { id: 'STC089', category: 'Navigation & Routing', description: 'Verify 404 state for unknown hash routes shows fallback UI' },
  { id: 'STC090', category: 'Navigation & Routing', description: 'Verify forward browser navigation restores correct screen state' },

  // ── 10. Performance Testing (91-100) ──
  { id: 'STC091', category: 'Performance Testing', description: 'Verify Total Blocking Time (TBT) is under 300ms on load' },
  { id: 'STC092', category: 'Performance Testing', description: 'Verify Cumulative Layout Shift (CLS) score is below 0.1' },
  { id: 'STC093', category: 'Performance Testing', description: 'Verify First Contentful Paint (FCP) renders within 2.5 seconds' },
  { id: 'STC094', category: 'Performance Testing', description: 'Verify flutter_bootstrap.js load does not block main thread' },
  { id: 'STC095', category: 'Performance Testing', description: 'Verify screen transitions animate within 16ms per frame (60 FPS)' },
  { id: 'STC096', category: 'Performance Testing', description: 'Verify API calls complete under 3 seconds under normal network conditions' },
  { id: 'STC097', category: 'Performance Testing', description: 'Verify DOM node count stays under 3000 to prevent memory bloat' },
  { id: 'STC098', category: 'Performance Testing', description: 'Verify heap memory usage stays below 100MB during session' },
  { id: 'STC099', category: 'Performance Testing', description: 'Verify service worker registers successfully for PWA caching' },
  { id: 'STC100', category: 'Performance Testing', description: 'Verify assets (icons, fonts) load from cache on second visit' },

  // ── 11. Accessibility Testing (101-110) ──
  { id: 'STC101', category: 'Accessibility Testing', description: 'Verify all form inputs have associated label or aria-label attributes' },
  { id: 'STC102', category: 'Accessibility Testing', description: 'Verify buttons have accessible name via text content or aria-label' },
  { id: 'STC103', category: 'Accessibility Testing', description: 'Verify focus is visible on keyboard-navigable elements' },
  { id: 'STC104', category: 'Accessibility Testing', description: 'Verify colour is not the only means of conveying information' },
  { id: 'STC105', category: 'Accessibility Testing', description: 'Verify page has a single <h1> element per screen for screen readers' },
  { id: 'STC106', category: 'Accessibility Testing', description: 'Verify images have non-empty alt attributes' },
  { id: 'STC107', category: 'Accessibility Testing', description: 'Verify interactive elements have minimum 44x44px touch target size' },
  { id: 'STC108', category: 'Accessibility Testing', description: 'Verify keyboard Tab order follows logical reading sequence' },
  { id: 'STC109', category: 'Accessibility Testing', description: 'Verify error messages are announced via aria-live regions' },
  { id: 'STC110', category: 'Accessibility Testing', description: 'Verify language attribute (lang="en") is set on the root html element' },

  // ── 12. End-to-End Flow Testing (111-120) ──
  { id: 'STC111', category: 'End-to-End Flow Testing', description: 'E2E: Open app → verify login screen → submit empty form → confirm validation error' },
  { id: 'STC112', category: 'End-to-End Flow Testing', description: 'E2E: Open app → click Sign Up → fill form → submit → verify redirect or response' },
  { id: 'STC113', category: 'End-to-End Flow Testing', description: 'E2E: Open app → attempt Google Sign-In → verify OAuth popup trigger' },
  { id: 'STC114', category: 'End-to-End Flow Testing', description: 'E2E: Simulate auth session → load dashboard → verify user name header' },
  { id: 'STC115', category: 'End-to-End Flow Testing', description: 'E2E: Navigate to Resume Upload → verify all UI elements load → navigate back' },
  { id: 'STC116', category: 'End-to-End Flow Testing', description: 'E2E: Navigate to Mock Interview → enter job role → click Start → verify question display' },
  { id: 'STC117', category: 'End-to-End Flow Testing', description: 'E2E: Navigate to Profile → verify user info → click Logout → confirm dialog → verify login screen' },
  { id: 'STC118', category: 'End-to-End Flow Testing', description: 'E2E: Full user journey from login → dashboard → resume → interview → profile → logout' },
  { id: 'STC119', category: 'End-to-End Flow Testing', description: 'E2E: Verify session persistence across tab refresh after authentication' },
  { id: 'STC120', category: 'End-to-End Flow Testing', description: 'E2E: Test PWA install prompt or service worker activation after full page load' },
];

const CATEGORY_COLORS = {
  'Page Load & Rendering':       { fill: 'FFE3F2FD', font: 'FF0D47A1' },
  'Authentication - Login':      { fill: 'FFE8F5E9', font: 'FF1B5E20' },
  'Authentication - Signup':     { fill: 'FFFFF3E0', font: 'FFE65100' },
  'Dashboard Screen':            { fill: 'FFEDE7F6', font: 'FF4A148C' },
  'Resume Upload Screen':        { fill: 'FFFCE4EC', font: 'FFB71C1C' },
  'Mock Interview Screen':       { fill: 'FFE0F7FA', font: 'FF006064' },
  'Profile Screen':              { fill: 'FFF3E5F5', font: 'FF6A1B9A' },
  'UI & Visual Regression':      { fill: 'FFFFF8E1', font: 'FFF57F17' },
  'Navigation & Routing':        { fill: 'FFE0F2F1', font: 'FF004D40' },
  'Performance Testing':         { fill: 'FFE8EAF6', font: 'FF1A237E' },
  'Accessibility Testing':       { fill: 'FFFFF9C4', font: 'FFF9A825' },
  'End-to-End Flow Testing':     { fill: 'FFE1F5FE', font: 'FF01579B' },
};

module.exports = { WEB_TEST_CASES, CATEGORY_COLORS };
