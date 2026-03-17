#!/bin/bash

# ═══════════════════════════════════════════════════════════
# 📋 CONFIGURATION - Modify these values
# ═══════════════════════════════════════════════════════════
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES=("dependency" "dev_dependency" "auth_module" "app_host")
DELETE_CONFLICTING=true
# ═══════════════════════════════════════════════════════════

# Run build_runner for code generation (freezed, routes, DI, JSON serialization)
# Usage: ./script/build_runner.sh

set -e

cd "$SCRIPT_DIR"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_header() {
  echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠ $1${NC}"
}

print_header "Running build_runner for code generation..."
echo ""

for pkg in "${PACKAGES[@]}"; do
  if [ -d "$pkg" ]; then
    if grep -q "build_runner" "$pkg/pubspec.yaml" 2>/dev/null; then
      print_header "Building: $pkg"
      cd "$pkg"

      if [ "$DELETE_CONFLICTING" = true ]; then
        flutter pub run build_runner build --delete-conflicting-outputs 2>&1 | grep -v "^Building" | grep -v "^Compiling" || true
      else
        flutter pub run build_runner build 2>&1 | grep -v "^Building" | grep -v "^Compiling" || true
      fi

      cd "$SCRIPT_DIR"
      print_success "Code generated: $pkg"
      echo ""
    fi
  fi
done

print_success "Build runner complete!"
print_header "Generated files:"
echo "  • Freezed models (.freezed.dart, .g.dart)"
echo "  • AutoRoute routes (.gr.dart)"
echo "  • Injectable DI (.config.dart)"
echo "  • JSON serialization (.g.dart)"
