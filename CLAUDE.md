# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an **AI Readiness Audit** interactive web application designed as a lead qualification tool for AI automation consultants. It's a single-page HTML application that calculates ROI for process automation and assesses client readiness.

The application guides prospects through a structured audit that:
1. Calculates the financial cost of manual processes (monthly/annual waste)
2. Assesses technical complexity (number of apps, AI requirements, data types)
3. Evaluates implementation readiness (documentation, authorization)
4. Provides personalized recommendations based on the calculated scores

## Deployment

**IMPORTANT:** This application is deployed and live on **GitHub Pages**. Any changes to `index.html` will affect the production site once pushed to the repository and deployed.

When making changes:
- Test thoroughly locally before committing
- Be aware that commits to `main` branch will trigger GitHub Pages deployment
- Changes are user-facing and impact live prospects using the audit tool

## Architecture

### Single-File Application
The entire application is contained in `index.html` (1102 lines):
- **Lines 1-547**: CSS styling with gradient themes, responsive cards, print styles, and mobile responsive design
- **Lines 548-858**: HTML structure with single-page scrolling navigation and form inputs
- **Lines 860-1098**: JavaScript for calculations, form submission, and dynamic recommendations
- **Lines 1100**: Scroll-to-top button element

### Key Components

**Navigation System** (lines 558-563):
- Single-page scrolling design with smooth anchor link navigation
- Sticky navigation bar (lines 58-82)
- ROI Calculator: Q1-Q4 for cost analysis
- Complexity: Q5-Q7 for technical assessment
- Readiness: Q8-Q9 for implementation readiness
- Score: Dashboard with real-time visualization of calculated metrics

**Header & Branding** (lines 551-556):
- Logo image reference from ai-agent-services.com
- Branded header with company link
- Favicon integration (line 7)

**Core Calculation Logic** (lines 861-964):
- `calculate()`: Main function triggered on all input changes via `oninput="calculate()"`
- Monthly waste formula: `(Q1 × Q2 / 60) × Q3 + Q4` (line 869)
- Annual waste: `monthlyWaste × 12` (line 870)
- App count detection from textarea using comma/newline split (lines 878-896)
- Complexity scoring based on app count, AI requirement, and data type (lines 929-943)
- Readiness scoring based on documentation and authorization status (lines 945-957)

**Recommendation Engine** (lines 966-1015):
- **Perfect Lead**: Annual waste ≥ $40k + requires AI → "Book Strategy Call" (lines 977-987)
- **Low Value**: Annual waste < $10k → "DIY with ChatGPT/Zapier" (lines 989-1000)
- **Medium Value**: $10k-$40k → Custom recommendation based on complexity (lines 1002-1014)

**Form Submission** (lines 1036-1078):
- Webhook endpoint: `https://n8n.dataflow-labs.de/webhook/36841c3f-a6fc-4187-9171-09023bb74602`
- POST request with JSON payload containing user info and calculated results
- Includes loading state and error handling

**Scroll-to-Top Button** (lines 1080-1096):
- Appears after scrolling 300px down
- Smooth scroll behavior to top of page
- Positioned fixed at bottom-right corner

### Question Logic

**Section 1 - ROI Calculator:**
- Q1: Task frequency (monthly occurrences)
- Q2: Time per instance (minutes)
- Q3: Hourly cost ($40-$80/hr typical)
- Q4: Cost of error (financial impact of mistakes)

**Section 2 - Complexity:**
- Q5: App count (text input parsed by commas) → ≤2 apps = Simple, 3+ = Complex
- Q6: Cognitive load (radio) → Yes = AI needed, No = Simple automation
- Q7: Data type (radio) → Unstructured = Complex, Structured = Simple

**Section 3 - Readiness:**
- Q8: Documentation exists (radio) → No = needs Discovery Workshop
- Q9: Budget/permissions (radio) → No = IT approval delays

## Development Commands

### Run Locally
```bash
# Open directly in browser
open index.html
# or on Linux
xdg-open index.html
```

### Docker Commands
```bash
# Build image
docker build -t ai-readiness-audit .

# Run container
docker run -d -p 8080:80 ai-readiness-audit

# Access at http://localhost:8080

# Stop container
docker ps
docker stop <container-id>

# Remove container and image
docker rm <container-id>
docker rmi ai-readiness-audit
```

### File References
- Main file: `index.html`
- Documentation: `instructions.md` (strategic design document)
- README: `README.md` (user-facing quick start)
- Dockerfile: Uses nginx:alpine to serve the HTML file
- Logo: `assets/Logo_Favicon.png` (local logo file)
- Favicon: Remote URL from ai-agent-services.com

## New Features (vs Original Version)

### Form Submission with Webhook Integration
- Lead capture form at the bottom of the dashboard (lines 824-855)
- Collects: First Name, Last Name, Company Name, Email
- Hidden fields automatically populated with calculated results
- Webhook endpoint: `https://n8n.dataflow-labs.de/webhook/36841c3f-a6fc-4187-9171-09023bb74602`
- Full error handling and loading states

### Single-Page Scrolling Design
- Changed from tab-based navigation to smooth-scrolling anchor links
- Sticky navigation bar that follows user while scrolling
- All sections visible on one page for better UX
- Scroll-to-top button for easy navigation back to top

### Enhanced Mobile Responsiveness
- Three-tier responsive design (desktop, tablet/mobile, small mobile)
- Navigation collapses to 2-column grid on tablets, full-width on mobile
- Dashboard cards stack vertically on mobile devices
- Font sizes and padding optimized for small screens

### Branding Integration
- Company logo and branding from AI Agent Services
- Teal-to-blue color scheme (#1FC7C7 → #2B7FE8) replacing previous purple theme
- Favicon integration
- Header includes link to ai-agent-services.com

## Key Implementation Details

### Real-time Updates
All form inputs trigger `calculate()` via `oninput` or `onchange` attributes, providing instant feedback on the dashboard. Smooth scroll behavior enabled site-wide (line 54-56).

### Dashboard Cards
Four main metrics displayed (lines 776-797):
- Monthly Waste
- Annual Waste
- Complexity Score (Low/Medium/High/Expert)
- Readiness Level (✓ Ready / ⚠️ Partial / ✗ Not Ready)

Additional complexity breakdown (lines 799-815):
- Apps Involved indicator
- AI Required indicator (🤖 or ✓)
- Data Type indicator (📄 or 📊)

### Number Formatting
The application uses JavaScript's regex-based thousand separators:
```javascript
.replace(/\B(?=(\d{3})+(?!\d))/g, ",")
```

### Spinner Removal
Number inputs have spinner arrows disabled via CSS (lines 139-148) for cleaner UI.

### Print Functionality
CSS includes `@media print` rules (lines 403-414) to show all sections when printing and hide navigation elements.

## Modifying the Application

### Changing Thresholds
Key thresholds in `generateRecommendation()` function (line 966):
- Low value threshold: `annualWaste < 10000` (line 989)
- Perfect lead threshold: `annualWaste >= 40000 && requiresAI` (line 977)
- Medium value threshold: Between $10k-$40k (line 1002)

### Styling
Primary gradient colors (teal to blue theme):
- Main gradient: `linear-gradient(135deg, #1FC7C7 0%, #2B7FE8 100%)`
- Applied to: body background (line 17), header (line 32), section headers (line 94), dashboard cards (line 190), submit button (line 348), scroll-to-top button (line 377)
- Border accent color: `#2B7FE8` used throughout for focus states and borders

### Responsive Design
Three breakpoints for mobile optimization:
- **768px and below** (lines 416-523): Tablet/mobile layout adjustments
- **480px and below** (lines 525-546): Small mobile device optimization
- Features: Collapsible navigation, stacked grid layouts, adjusted font sizes

### Formula Adjustments
Monthly waste calculation is at line 869:
```javascript
const monthlyWaste = (q1 * q2 / 60) * q3 + q4;
```

## Known Quirks

1. **DUPLICATE SECTION 1**: Lines 566-614 and 615-663 contain duplicate ROI Calculator sections. The first instance (lines 566-614) appears to be incomplete/orphaned. This should be removed in the next update.
2. Q4 (cost of error) is added directly to monthly waste rather than multiplied by error rate - it's treated as a monthly expected cost
3. App count is text-parsed by splitting on commas and newlines (`q5.split(/[,\n]/)`) - no validation for empty entries or whitespace (line 880)
4. All calculations use `parseFloat() || 0` for safe handling of empty inputs
5. Radio buttons don't have a "reset" option - once selected, user must choose one of the options
6. Form data includes hidden fields that are updated in real-time via `updateFormData()` function (lines 1017-1030)
7. The logo image is loaded from a local path (`assets/Logo_Favicon.png`) while the favicon loads from the remote URL
