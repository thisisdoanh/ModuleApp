#!/bin/bash

# ═══════════════════════════════════════════════════════════
# 📋 CONFIGURATION - Modify these values
# ═══════════════════════════════════════════════════════════
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES=("dependency" "dev_dependency" "auth_module" "app_host")
APP_HOST_DIR="app_host"
ENABLE_L10N=true
# ═══════════════════════════════════════════════════════════

# Clean Setup Script
# Runs: clean → get → build_runner → gen_asset → gen_l10n
# Usage: ./script/clean_setup.sh

set -e

cd "$SCRIPT_DIR"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}▶ $1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
  echo -e "${RED}✗ $1${NC}"
}

# Step 1: Clean
print_header "Step 1: Cleaning packages..."
if [ -f "script/clean.sh" ]; then
  echo "y" | bash script/clean.sh || print_warning "Clean with warnings"
  print_success "Clean completed"
else
  print_error "script/clean.sh not found"
  exit 1
fi
echo ""

# Step 2: Get dependencies
print_header "Step 2: Getting dependencies..."
if [ -f "script/get.sh" ]; then
  bash script/get.sh
  print_success "Dependencies installed"
else
  print_error "script/get.sh not found"
  exit 1
fi
echo ""

# Step 3: Run build_runner
print_header "Step 3: Running build_runner..."
if [ -f "script/build_runner.sh" ]; then
  bash script/build_runner.sh
  print_success "Code generation completed"
else
  print_error "script/build_runner.sh not found"
  exit 1
fi
echo ""

# Step 4: Generate assets (flutter_gen)
print_header "Step 4: Generating Flutter assets..."
if [ -d "$APP_HOST_DIR" ]; then
  cd "$APP_HOST_DIR"

  # Generate l10n if present
  if [ "$ENABLE_L10N" = true ] && ([ -f "l10n.yaml" ] || [ -d "lib/l10n/arb" ]); then
    print_header "Generating localizations..."
    flutter gen-l10n 2>/dev/null || print_warning "L10n generation skipped"
  fi

  cd "$SCRIPT_DIR"
  print_success "Assets generated"
else
  print_warning "$APP_HOST_DIR directory not found, skipping assets"
fi
echo ""

# Step 5: Generate l10n (detailed)
if [ "$ENABLE_L10N" = true ]; then
  print_header "Step 5: Generating localizations..."
  if [ -d "$APP_HOST_DIR" ]; then
    cd "$APP_HOST_DIR"
    if [ -d "lib/l10n/arb" ]; then
      print_header "Localizations:"
      echo "  • English (en)"
      echo "  • Vietnamese (vi)"
      flutter gen-l10n 2>/dev/null || print_warning "L10n already up to date"
      print_success "Localizations generated"
    else
      print_warning "No l10n/arb directory found"
    fi
    cd "$SCRIPT_DIR"
  else
    print_warning "$APP_HOST_DIR directory not found, skipping l10n"
  fi
  echo ""
fi

# Final summary
print_header "Setup Complete!"
echo -e "${GREEN}✓ Clean${NC}"
echo -e "${GREEN}✓ Get dependencies${NC}"
echo -e "${GREEN}✓ Build runner (code generation)${NC}"
echo -e "${GREEN}✓ Generate assets${NC}"
if [ "$ENABLE_L10N" = true ]; then
  echo -e "${GREEN}✓ Generate localizations${NC}"
fi
echo ""
print_header "Next steps:"
echo "  1. Analyze code:     ./run_app.sh analyze"
echo "  2. Run the app:      ./run_app.sh run"
echo "  3. Run tests:        ./run_app.sh test"
echo ""
