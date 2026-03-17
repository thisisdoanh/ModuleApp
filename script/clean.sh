#!/bin/bash

# ═══════════════════════════════════════════════════════════
# 📋 CONFIGURATION - Modify these values
# ═══════════════════════════════════════════════════════════
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES=("dependency" "dev_dependency" "auth_module" "app_host")
CONFIRM_BEFORE_CLEAN=true
# ═══════════════════════════════════════════════════════════

# Clean all packages
# Usage: ./script/clean.sh

set -e

cd "$SCRIPT_DIR"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
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

confirm_action() {
  local prompt=$1
  local response
  read -p "$(echo -e ${YELLOW}${prompt}${NC})" -n 1 -r response
  echo ""
  if [[ $response =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
}

echo -e "${YELLOW}This will clean all packages and remove:${NC}"
echo "  • build/ directories"
echo "  • .dart_tool/ directories"
echo "  • pubspec.lock files"
echo ""

if [ "$CONFIRM_BEFORE_CLEAN" = true ]; then
  if ! confirm_action "Do you want to continue? (y/n) "; then
    print_warning "Clean cancelled"
    exit 0
  fi
fi

echo ""
print_header "Cleaning all packages..."
echo ""

for pkg in "${PACKAGES[@]}"; do
  if [ -d "$pkg" ]; then
    print_header "Cleaning: $pkg"
    cd "$pkg"

    [ -d "build" ] && rm -rf build && print_success "Removed build/"
    [ -d ".dart_tool" ] && rm -rf .dart_tool && print_success "Removed .dart_tool/"
    [ -f "pubspec.lock" ] && rm -f pubspec.lock && print_success "Removed pubspec.lock"

    flutter clean 2>/dev/null || print_warning "flutter clean skipped"

    cd "$SCRIPT_DIR"
  fi
done

print_header "Cleaning root..."
[ -d "build" ] && rm -rf build && print_success "Removed build/"
[ -d ".dart_tool" ] && rm -rf .dart_tool && print_success "Removed .dart_tool/"
[ -f "pubspec.lock" ] && rm -f pubspec.lock && print_success "Removed pubspec.lock"

echo ""
print_success "All packages cleaned!"
