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
The entire application is contained in `index.html` (697 lines):
- **Lines 1-292**: CSS styling with gradient themes, responsive cards, and print styles
- **Lines 293-518**: HTML structure with tab navigation and form inputs
- **Lines 520-695**: JavaScript for calculations, tab switching, and dynamic recommendations

### Key Components

**Tab System** (lines 301-306):
- Dashboard: Real-time visualization of calculated metrics
- Section 1 (Cost Analysis): Q1-Q4 for ROI calculation
- Section 2 (Complexity): Q5-Q7 for technical assessment
- Section 3 (Readiness): Q8-Q9 for implementation readiness

**Core Calculation Logic** (lines 539-638):
- `calculate()`: Main function triggered on all input changes via `oninput="calculate()"`
- Monthly waste formula: `(Q1 × Q2 / 60) × Q3 + Q4`
- Annual waste: `monthlyWaste × 12`
- Complexity scoring based on app count, AI requirement, and data type
- Readiness scoring based on documentation and authorization status

**Recommendation Engine** (lines 640-689):
- **Perfect Lead**: Annual waste ≥ $40k + requires AI → "Book Strategy Call"
- **Low Value**: Annual waste < $10k → "DIY with ChatGPT/Zapier"
- **Medium Value**: $10k-$40k → Custom recommendation based on complexity

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

## Key Implementation Details

### Real-time Updates
All form inputs trigger `calculate()` via `oninput` or `onchange` attributes, providing instant feedback on the dashboard.

### Dashboard Cards
Four main metrics displayed (lines 316-337):
- Monthly Waste
- Annual Waste
- Complexity Score (Low/Medium/High/Expert)
- Readiness Level (✓ Ready / ⚠️ Partial / ✗ Not Ready)

### Number Formatting
The application uses JavaScript's regex-based thousand separators:
```javascript
.replace(/\B(?=(\d{3})+(?!\d))/g, ",")
```

### Spinner Removal
Number inputs have spinner arrows disabled via CSS (lines 139-148) for cleaner UI.

### Print Functionality
CSS includes `@media print` rules (lines 283-291) to show all sections when printing.

## Modifying the Application

### Changing Thresholds
Key thresholds in `generateRecommendation()` function (line 640):
- Low value threshold: `annualWaste < 10000` (line 663)
- Perfect lead threshold: `annualWaste >= 40000 && requiresAI` (line 651)
- Medium value threshold: Between $10k-$40k

### Styling
Primary gradient colors defined multiple times:
- Main gradient: `#667eea` to `#764ba2`
- Modify at lines 16, 31, 89, 185 for consistent theme changes

### Formula Adjustments
Monthly waste calculation is at line 547:
```javascript
const monthlyWaste = (q1 * q2 / 60) * q3 + q4;
```

## Known Quirks

1. Q4 (cost of error) is added directly to monthly waste rather than multiplied by error rate - it's treated as a monthly expected cost
2. App count is text-parsed by splitting on commas - no validation for empty entries or whitespace
3. All calculations use `parseFloat() || 0` for safe handling of empty inputs
4. Radio buttons don't have a "reset" option - once selected, user must choose one of the options
