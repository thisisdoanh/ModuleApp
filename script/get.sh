#!/bin/bash

# ═══════════════════════════════════════════════════════════
# 📋 CONFIGURATION - Modify these values
# ═══════════════════════════════════════════════════════════
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES=("dependency" "dev_dependency" "auth_module" "app_host")
# ═══════════════════════════════════════════════════════════

# Get dependencies for all packages
# Usage: ./script/get.sh

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

print_header "Getting dependencies for all packages..."
echo ""

for pkg in "${PACKAGES[@]}"; do
  if [ -d "$pkg" ]; then
    print_header "Getting deps: $pkg"
    cd "$pkg"
    flutter pub get
    cd "$SCRIPT_DIR"
  fi
done

print_success "All dependencies installed!"
