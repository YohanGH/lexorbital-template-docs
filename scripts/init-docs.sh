#!/usr/bin/env bash
# ============================================================================
# init-docs.sh
# Initialize the documentation structure in a new LexOrbital repository
# ============================================================================
# Usage:
#   ./init-docs.sh --target ../lexorbital-module-xyz --type infra --language fr
# ============================================================================

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")/template"
TARGET_REPO=""
MODULE_TYPE="infra"
LANGUAGE="fr"  # fr | en
DRY_RUN=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
}

# Validate path format (prevent path traversal)
validate_path() {
    local path="$1"
    local path_type="$2"
    
    # Allow relative paths with .. (they will be safely resolved later)
    # Only reject obviously malicious patterns like starting with /../ or excessive ../ sequences
    if [[ "$path" =~ ^/\.\./ ]] || [[ "$path" =~ ^\.\./\.\./\.\./\.\./ ]]; then
        log_error "Invalid ${path_type}: suspicious path traversal pattern in '$path'"
        return 1
    fi
    
    # Check for absolute paths (if relative expected)
    if [[ "$path_type" == "relative" ]] && [[ "$path" =~ ^/ ]]; then
        log_error "Invalid ${path_type}: absolute path not allowed: '$path'"
        return 1
    fi
    
    return 0
}

# Validate module type
validate_module_type() {
    local type="$1"
    case "$type" in
        infra|ui|api|cli)
            return 0
            ;;
        *)
            log_error "Invalid module type: '$type' (allowed: infra, ui, api, cli)"
            return 1
            ;;
    esac
}

# Validate language
validate_language() {
    local lang="$1"
    case "$lang" in
        fr|en)
            return 0
            ;;
        *)
            log_error "Invalid language: '$lang' (allowed: fr, en)"
            return 1
            ;;
    esac
}

# Parse arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --target)
                TARGET_REPO="$2"
                shift 2
                ;;
            --type)
                MODULE_TYPE="$2"
                shift 2
                ;;
            --language)
                LANGUAGE="$2"
                shift 2
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

show_usage() {
    cat << EOF
Usage: $0 --target TARGET_REPO [OPTIONS]

Initialize the documentation structure in a new LexOrbital repository.

Options:
    --target TARGET_REPO    Path to the target repository
    --type MODULE_TYPE      Module type: infra | ui | api | cli (default: infra)
    --language LANG         Documentation language: fr | en (default: fr)
    --dry-run               Simulate without making modifications
    --help                  Show this help message

Module types:
    infra   Infrastructure module (server, deployment, etc.)
    ui      UI/frontend module
    api     API/backend module
    cli     CLI/tooling module

Examples:
    # Initialize French infrastructure module
    $0 --target ../lexorbital-module-server --type infra --language fr

    # Initialize English UI module
    $0 --target ../lexorbital-module-dashboard --type ui --language en

    # Dry run
    $0 --target ../lexorbital-module-test --dry-run
EOF
}

# Validate target repository
validate_target() {
    log_info "Validating target repository..."
    
    # Validate path format
    if ! validate_path "$TARGET_REPO" "target path"; then
        exit 1
    fi
    
    # Resolve absolute path
    TARGET_REPO="$(cd "$(dirname "$TARGET_REPO")" && pwd)/$(basename "$TARGET_REPO")"
    
    if [[ ! -d "$TARGET_REPO" ]]; then
        log_error "Target repository not found: $TARGET_REPO"
        exit 1
    fi
    
    # Verify template directory exists
    if [[ ! -d "$TEMPLATE_DIR" ]]; then
        log_error "Template directory not found: $TEMPLATE_DIR"
        exit 1
    fi
    
    if [[ -d "$TARGET_REPO/docs" ]]; then
        log_warn "The docs/ directory already exists in $TARGET_REPO"
        read -p "Do you want to continue? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Cancelled by user"
            exit 0
        fi
    fi
    
    log_info "✅ Repository validated"
}

# Create documentation structure
create_structure() {
    log_info "Creating documentation structure..."
    
    local target_docs="$TARGET_REPO/docs"
    
    # Base directories
    local base_dirs=(
        "project"
        "architecture"
        "architecture/diagrams"
        "compliance"
        "compliance/diagrams"
        "operations"
        "security"
        "howto"
        "reference"
        "template"
        "template/examples"
    )
    
    # Create language-specific structure
    case "$LANGUAGE" in
        fr)
            log_info "French structure"
            for dir in "${base_dirs[@]}"; do
                local target_dir="$target_docs/fr/$dir"
                # Validate path doesn't escape target
                if [[ "$target_dir" != "$TARGET_REPO/docs/fr/"* ]]; then
                    log_error "Invalid path detected: $target_dir"
                    exit 1
                fi
                
                if [[ "$DRY_RUN" == false ]]; then
                    if mkdir -p "$target_dir"; then
                        log_debug "Created $target_dir"
                    else
                        log_error "Failed to create directory: $target_dir"
                        exit 1
                    fi
                else
                    log_debug "[DRY-RUN] Would create $target_dir"
                fi
            done
            ;;
        en)
            log_info "English structure"
            for dir in "${base_dirs[@]}"; do
                local target_dir="$target_docs/en/$dir"
                # Validate path doesn't escape target
                if [[ "$target_dir" != "$TARGET_REPO/docs/en/"* ]]; then
                    log_error "Invalid path detected: $target_dir"
                    exit 1
                fi
                
                if [[ "$DRY_RUN" == false ]]; then
                    if mkdir -p "$target_dir"; then
                        log_debug "Created $target_dir"
                    else
                        log_error "Failed to create directory: $target_dir"
                        exit 1
                    fi
                else
                    log_debug "[DRY-RUN] Would create $target_dir"
                fi
            done
            ;;
        *)
            log_error "Invalid language: $LANGUAGE (only fr or en allowed)"
            exit 1
            ;;
    esac
    
    log_info "✅ Structure created ($LANGUAGE)"
}

# Copy template files
copy_templates() {
    log_info "Copying template files..."
    
    local target_docs="$TARGET_REPO/docs"
    
    # Copy meta-documentation based on language
    local meta_files=(
        "template/style-guide.md"
        "template/docs-structure.md"
    )
    
    if [[ "$LANGUAGE" == "fr" ]]; then
        for file in "${meta_files[@]}"; do
            local source_file="$TEMPLATE_DIR/docs/fr/$file"
            local target_file="$target_docs/fr/$file"
            
            # Validate paths
            if [[ "$target_file" != "$TARGET_REPO/docs/fr/"* ]]; then
                log_error "Invalid target path: $target_file"
                continue
            fi
            
            if [[ -f "$source_file" ]] && [[ "$DRY_RUN" == false ]]; then
                if mkdir -p "$(dirname "$target_file")"; then
                    if cp "$source_file" "$target_file"; then
                        log_debug "Copied $file (FR)"
                    else
                        log_error "Failed to copy $file"
                    fi
                else
                    log_error "Failed to create directory: $(dirname "$target_file")"
                fi
            elif [[ "$DRY_RUN" == true ]]; then
                log_debug "[DRY-RUN] Would copy $file (FR)"
            fi
        done
    elif [[ "$LANGUAGE" == "en" ]]; then
        # For EN, copy minimal template files
        local source_file="$TEMPLATE_DIR/docs/en/template/i18n-guide.md"
        local target_file="$target_docs/en/template/i18n-guide.md"
        
        if [[ "$target_file" != "$TARGET_REPO/docs/en/"* ]]; then
            log_error "Invalid target path: $target_file"
        elif [[ -f "$source_file" ]] && [[ "$DRY_RUN" == false ]]; then
            if mkdir -p "$(dirname "$target_file")"; then
                if cp "$source_file" "$target_file"; then
                    log_debug "Copied i18n-guide.md (EN)"
                else
                    log_error "Failed to copy i18n-guide.md"
                fi
            else
                log_error "Failed to create directory: $(dirname "$target_file")"
            fi
        elif [[ "$DRY_RUN" == true ]]; then
            log_debug "[DRY-RUN] Would copy i18n-guide.md (EN)"
        fi
    fi
    
    log_info "✅ Templates copied ($LANGUAGE)"
}

# Create customized index.md
create_index() {
    log_info "Creating index.md files..."
    
    local target_docs="$TARGET_REPO/docs"
    local project_name=$(basename "$TARGET_REPO")
    
    # Validate project name
    if [[ ! "$project_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        log_error "Invalid project name format: $project_name"
        exit 1
    fi
    
    # Create French index
    if [[ "$LANGUAGE" == "fr" ]] && [[ "$DRY_RUN" == false ]]; then
        local target_file_fr="$target_docs/fr/index.md"
        
        # Validate path
        if [[ "$target_file_fr" != "$TARGET_REPO/docs/fr/"* ]]; then
            log_error "Invalid target path: $target_file_fr"
            exit 1
        fi
        
        if cat > "$target_file_fr" << EOF
# Documentation $project_name

> Complete documentation for deployment, maintenance and use of $project_name.

## 🗺️ Navigation by Role

### 👨‍💼 For Decision Makers / Recruiters

**Want to understand the project in 5 minutes?**

- [📖 Project Overview](./project/overview.md)
- [🏗️ System Architecture](./architecture/system-design.md)
- [⚖️ GDPR Compliance](./compliance/overview.md)

---

### 👨‍💻 For Developers

**Want to contribute or use this module?**

- [🚀 Development Environment](./howto/setup-dev-environment.md)
- [🤝 Contribution Guide](./howto/contribute.md)
- [🔧 Troubleshooting](./howto/troubleshooting.md)

---

### 🔧 For DevOps / SysAdmins

**Want to deploy and maintain?**

- [📋 Prerequisites](./operations/prerequisites.md)
- [⚙️ Installation](./operations/installation.md)
- [🚀 Deployment](./operations/deployment.md)
- [🔄 Backup & Recovery](./operations/backup-recovery.md)

---

### 🔒 For Security / Compliance

**Want to audit security and compliance?**

- [🛡️ Security Standards](./compliance/security-standards.md)
- [⚖️ GDPR Technical Measures](./compliance/gdpr-technical.md)
- [🔐 System Hardening](./security/hardening.md)

---

## 📖 Complete Table of Contents

### 📁 Project

- [Overview](./project/overview.md)
- [Roadmap](./project/roadmap.md)
- [Glossary](./project/glossary.md)

### 🏗️ Architecture

- [System Design](./architecture/system-design.md)
- [Infrastructure](./architecture/infrastructure.md)
- [Diagrams](./architecture/diagrams/)

### ⚖️ Compliance

- [Overview](./compliance/overview.md)
- [GDPR Technical Measures](./compliance/gdpr-technical.md)
- [Security Standards](./compliance/security-standards.md)

### 🔧 Operations

- [Prerequisites](./operations/prerequisites.md)
- [Installation](./operations/installation.md)
- [Deployment](./operations/deployment.md)

### 🔒 Security

- [System Hardening](./security/hardening.md)
- [SSH Configuration](./security/ssh-configuration.md)
- [Permissions Audit](./security/permissions-audit.md)

### 🎯 Practical Guides

- [Setup Development Environment](./howto/setup-dev-environment.md)
- [Troubleshooting](./howto/troubleshooting.md)
- [Contribute](./howto/contribute.md)

### 📚 Reference

- [Utility Scripts](./reference/scripts.md)
- [External Resources](./reference/resources.md)

---

**Last updated:** $(date +%Y-%m-%d)  
**Documentation version:** 1.0.0
EOF
        then
            log_debug "Created index.md (FR)"
        else
            log_error "Failed to create index.md (FR)"
            exit 1
        fi
    fi
    
    # Create English index
    if [[ "$LANGUAGE" == "en" ]] && [[ "$DRY_RUN" == false ]]; then
        local target_file_en="$target_docs/en/index.md"
        
        # Validate path
        if [[ "$target_file_en" != "$TARGET_REPO/docs/en/"* ]]; then
            log_error "Invalid target path: $target_file_en"
            exit 1
        fi
        
        if cat > "$target_file_en" << EOF
# $project_name Documentation

> **Professional showcase documentation** for $project_name.

**🌍 Available languages:** [🇫🇷 Français](../fr/index.md) (complete) • [🇬🇧 English](../en/index.md) (showcase)

---

## 🎯 About This Documentation

This is the **English showcase version** highlighting key aspects.

For complete technical documentation, please refer to the [French version](../fr/index.md).

---

## 🗺️ Navigation

### 👨‍💼 For Decision Makers

- [📖 Project Overview](./project/overview.md)
- [🏗️ System Architecture](./architecture/system-design.md)
- [⚖️ GDPR Compliance](./compliance/gdpr-overview.md)

### 🚀 Getting Started

- [Quick Start](./operations/quickstart.md)

---

**Last updated:** $(date +%Y-%m-%d)  
**Documentation version:** 1.0.0
EOF
        then
            log_debug "Created index.md (EN)"
        else
            log_error "Failed to create index.md (EN)"
            exit 1
        fi
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        log_debug "[DRY-RUN] Would create index.md ($LANGUAGE)"
    fi
    
    log_info "✅ Index created ($LANGUAGE)"
}

# Create placeholder files
create_placeholders() {
    log_info "Creating placeholder files..."
    
    local target_docs="$TARGET_REPO/docs"
    local project_name=$(basename "$TARGET_REPO")
    
    # Standard files
    local files=(
        "project/overview.md:Overview"
        "project/roadmap.md:Roadmap"
        "project/glossary.md:Glossary"
        "architecture/system-design.md:System Design"
        "architecture/infrastructure.md:Infrastructure"
        "compliance/overview.md:Compliance Overview"
        "compliance/gdpr-technical.md:GDPR Technical Measures"
        "compliance/security-standards.md:Security Standards"
        "operations/prerequisites.md:Prerequisites"
        "operations/installation.md:Installation"
        "operations/deployment.md:Deployment"
        "security/hardening.md:System Hardening"
        "security/ssh-configuration.md:SSH Configuration"
        "security/permissions-audit.md:Permissions Audit"
        "howto/setup-dev-environment.md:Development Environment Setup"
        "howto/troubleshooting.md:Troubleshooting"
        "howto/contribute.md:Contribution Guide"
        "reference/scripts.md:Utility Scripts"
        "reference/resources.md:External Resources"
    )
    
    for item in "${files[@]}"; do
        IFS=':' read -r file title <<< "$item"
        local target_file="$target_docs/$LANGUAGE/$file"
        
        # Validate path
        if [[ "$target_file" != "$TARGET_REPO/docs/$LANGUAGE/"* ]]; then
            log_error "Invalid target path: $target_file"
            continue
        fi
        
        if [[ ! -f "$target_file" ]] && [[ "$DRY_RUN" == false ]]; then
            if cat > "$target_file" << EOF
# $title

> **TODO:** Document to be completed

## 🎯 Objective

TODO: Describe the objective of this document.

## 📋 Content

TODO: Add content.

---

**Last updated:** $(date +%Y-%m-%d)  
**Status:** 🚧 Under construction
EOF
            then
                log_debug "Created placeholder $file"
            else
                log_error "Failed to create placeholder: $file"
            fi
        elif [[ "$DRY_RUN" == true ]]; then
            log_debug "[DRY-RUN] Would create placeholder $file"
        fi
    done
    
    log_info "✅ Placeholders created"
}

# Generate initialization report
generate_report() {
    log_info "==================================="
    log_info "📊 Initialization Report"
    log_info "==================================="
    log_info "Repository : $TARGET_REPO"
    log_info "Type       : $MODULE_TYPE"
    log_info "Language   : $LANGUAGE"
    log_info "Dry run    : $DRY_RUN"
    log_info "==================================="
}

# Main execution
main() {
    parse_args "$@"
    
    # Validate inputs
    if [[ -z "$TARGET_REPO" ]]; then
        log_error "Target repository required"
        show_usage
        exit 1
    fi
    
    if ! validate_module_type "$MODULE_TYPE"; then
        exit 1
    fi
    
    if ! validate_language "$LANGUAGE"; then
        exit 1
    fi
    
    echo ""
    log_info "📦 Initializing LexOrbital Documentation"
    echo ""
    
    validate_target
    create_structure
    copy_templates
    create_index
    create_placeholders
    
    echo ""
    generate_report
    echo ""
    log_info "🎉 Initialization completed!"
    echo ""
    log_info "Next steps:"
    log_info "  1. Edit docs/$LANGUAGE/index.md to customize navigation"
    log_info "  2. Complete placeholder files in docs/$LANGUAGE/"
    log_info "  3. Add diagrams in architecture/diagrams/"
    echo ""
}

main "$@"

