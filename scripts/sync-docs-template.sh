#!/usr/bin/env bash
# ============================================================================
# sync-docs-template.sh
# Synchronize the documentation structure between LexOrbital repositories
# ============================================================================
# Usage examples:
#   ./sync-docs-template.sh --source . --target ../lexorbital-module-server
# ============================================================================

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_REPO=""
TARGET_REPO=""
DRY_RUN=false
SYNC_MODE="structure" # structure | content | full
LANGUAGE="fr" # fr | en

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
    
    # Check for path traversal attempts
    if [[ "$path" =~ \.\. ]]; then
        log_error "Invalid ${path_type}: path traversal detected in '$path'"
        return 1
    fi
    
    return 0
}

# Validate sync mode
validate_sync_mode() {
    local mode="$1"
    case "$mode" in
        structure|content|full)
            return 0
            ;;
        *)
            log_error "Invalid sync mode: '$mode' (allowed: structure, content, full)"
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
            --source)
                SOURCE_REPO="$2"
                shift 2
                ;;
            --target)
                TARGET_REPO="$2"
                shift 2
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --mode)
                SYNC_MODE="$2"
                shift 2
                ;;
            --language)
                LANGUAGE="$2"
                shift 2
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
Usage: $0 --source SOURCE_REPO --target TARGET_REPO [OPTIONS]

Synchronize the documentation structure between LexOrbital repositories.

Options:
    --source SOURCE_REPO    Path to lexorbital-template-docs
    --target TARGET_REPO    Path to the target repository
    --mode MODE             Sync mode: structure | content | full (default: structure)
    --language LANG         Language: fr | en (default: fr)
    --dry-run               Simulate without making modifications
    --help                  Show this help message

Synchronization modes:
    structure   Create missing directories only
    content     Synchronize structure + template files
    full        Full synchronization (structure + templates + placeholders)

Examples:
    # Sync structure only
    $0 --source lexorbital-template-docs --target ../lexorbital-module-server

    # Sync structure and templates
    $0 --source . --target ../lexorbital-core --mode content

    # Dry run
    $0 --source . --target ../lexorbital-module-ui-kit --dry-run
EOF
}

# Validate repositories
validate_repos() {
    log_info "Validating repositories..."
    
    # Validate path formats
    if ! validate_path "$SOURCE_REPO" "source path"; then
        exit 1
    fi
    
    if ! validate_path "$TARGET_REPO" "target path"; then
        exit 1
    fi
    
    # Resolve absolute paths
    if [[ -d "$SOURCE_REPO" ]]; then
        SOURCE_REPO="$(cd "$(dirname "$SOURCE_REPO")" && pwd)/$(basename "$SOURCE_REPO")"
    else
        log_error "Source repository not found: $SOURCE_REPO"
        exit 1
    fi
    
    if [[ -d "$TARGET_REPO" ]]; then
        TARGET_REPO="$(cd "$(dirname "$TARGET_REPO")" && pwd)/$(basename "$TARGET_REPO")"
    else
        log_error "Target repository not found: $TARGET_REPO"
        exit 1
    fi
    
    # Verify source is a valid template repository
    if [[ ! -f "$SOURCE_REPO/template/docs/template/docs-structure.md" ]]; then
        log_error "Source repository is not a valid lexorbital-template-docs"
        exit 1
    fi
    
    log_info "✅ Repositories validated"
}

# Sync structure only (create missing directories)
sync_structure() {
    log_info "Synchronizing documentation structure ($LANGUAGE)..."
    
    local target_docs="$TARGET_REPO/docs"
    
    # Validate target_docs path
    if [[ "$target_docs" != "$TARGET_REPO/docs" ]]; then
        log_error "Invalid target docs path: $target_docs"
        exit 1
    fi
    
    # Create main docs directory if missing
    if [[ ! -d "$target_docs" ]]; then
        if [[ "$DRY_RUN" == false ]]; then
            if mkdir -p "$target_docs"; then
                log_info "Created $target_docs"
            else
                log_error "Failed to create directory: $target_docs"
                exit 1
            fi
        else
            log_debug "[DRY-RUN] Would create $target_docs"
        fi
    fi
    
    # Base subdirectories
    local dirs=(
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
            for dir in "${dirs[@]}"; do
                local target_dir="$target_docs/fr/$dir"
                
                # Validate path doesn't escape target
                if [[ "$target_dir" != "$TARGET_REPO/docs/fr/"* ]]; then
                    log_error "Invalid path detected: $target_dir"
                    exit 1
                fi
                
                if [[ ! -d "$target_dir" ]]; then
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
                fi
            done
            ;;
        en)
            for dir in "${dirs[@]}"; do
                local target_dir="$target_docs/en/$dir"
                
                # Validate path doesn't escape target
                if [[ "$target_dir" != "$TARGET_REPO/docs/en/"* ]]; then
                    log_error "Invalid path detected: $target_dir"
                    exit 1
                fi
                
                if [[ ! -d "$target_dir" ]]; then
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
                fi
            done
            ;;
        *)
            log_error "Invalid language: $LANGUAGE (only fr or en allowed)"
            exit 1
            ;;
    esac
    
    log_info "✅ Structure synchronization completed ($LANGUAGE)"
}

# Sync template files
sync_templates() {
    log_info "Synchronizing template files..."
    
    local template_files=(
        "template/style-guide.md"
        "template/docs-structure.md"
    )
    
    for file in "${template_files[@]}"; do
        local source_file="$SOURCE_REPO/template/docs/$LANGUAGE/$file"
        local target_file="$TARGET_REPO/docs/$LANGUAGE/$file"
        
        # Validate paths
        if [[ "$target_file" != "$TARGET_REPO/docs/$LANGUAGE/"* ]]; then
            log_error "Invalid target path: $target_file"
            continue
        fi
        
        if [[ -f "$source_file" ]]; then
            if [[ "$DRY_RUN" == false ]]; then
                # Check if target exists and backup
                if [[ -f "$target_file" ]]; then
                    local backup_file="${target_file}.backup-$(date +%F_%H-%M-%S)"
                    if cp "$target_file" "$backup_file" 2>/dev/null; then
                        log_debug "Backed up existing file: $backup_file"
                    fi
                fi
                
                if mkdir -p "$(dirname "$target_file")"; then
                    if cp "$source_file" "$target_file"; then
                        log_info "Copied $file"
                    else
                        log_error "Failed to copy $file"
                    fi
                else
                    log_error "Failed to create directory: $(dirname "$target_file")"
                fi
            else
                log_debug "[DRY-RUN] Would copy $file"
            fi
        else
            log_warn "Source file not found: $source_file"
        fi
    done
    
    log_info "✅ Template synchronization completed"
}

# Create placeholder files for missing docs
create_placeholders() {
    log_info "Creating placeholder files..."
    
    local target_docs="$TARGET_REPO/docs"
    
    # Standard files that should exist
    local required_files=(
        "index.md"
        "project/overview.md"
        "architecture/system-design.md"
        "compliance/overview.md"
        "operations/prerequisites.md"
        "operations/installation.md"
        "operations/deployment.md"
        "security/hardening.md"
        "howto/contribute.md"
        "howto/troubleshooting.md"
        "reference/resources.md"
    )
    
    for file in "${required_files[@]}"; do
        local target_file="$target_docs/$LANGUAGE/$file"
        
        # Validate path
        if [[ "$target_file" != "$TARGET_REPO/docs/$LANGUAGE/"* ]]; then
            log_error "Invalid target path: $target_file"
            continue
        fi
        
        if [[ ! -f "$target_file" ]]; then
            if [[ "$DRY_RUN" == false ]]; then
                # Simple title generation (avoid complex sed/awk)
                local basename_file=$(basename "$file" .md)
                local title=$(echo "$basename_file" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++){sub(/./,toupper(substr($i,1,1)),$i)}}1' 2>/dev/null || echo "$basename_file")
                
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
                    log_info "Created placeholder $file"
                else
                    log_error "Failed to create placeholder: $file"
                fi
            else
                log_debug "[DRY-RUN] Would create placeholder $file"
            fi
        fi
    done
    
    log_info "✅ Placeholders created"
}

# Validate target structure
validate_structure() {
    log_info "Validating documentation structure..."
    
    local target_docs="$TARGET_REPO/docs"
    local errors=0
    
    # Check required directories
    local required_dirs=(
        "project"
        "architecture"
        "compliance"
        "operations"
        "security"
        "howto"
        "reference"
        "template"
    )
    
    for dir in "${required_dirs[@]}"; do
        local check_dir="$target_docs/$LANGUAGE/$dir"
        if [[ ! -d "$check_dir" ]]; then
            log_warn "Missing directory: $LANGUAGE/$dir"
            ((errors++))
        fi
    done
    
    # Check for numbered files (anti-pattern)
    local numbered_files=$(find "$target_docs" -type f -name "[0-9][0-9]-*.md" 2>/dev/null | wc -l || echo "0")
    if [[ $numbered_files -gt 0 ]]; then
        log_warn "⚠️  Numbered files detected ($numbered_files) - renaming recommended"
        find "$target_docs" -type f -name "[0-9][0-9]-*.md" 2>/dev/null | while IFS= read -r file; do
            log_warn "  - $(basename "$file")"
        done
    fi
    
    if [[ $errors -eq 0 ]]; then
        log_info "✅ Structure validated"
    else
        log_warn "⚠️  $errors problem(s) detected"
    fi
    
    return 0
}

# Generate sync report
generate_report() {
    log_info "==================================="
    log_info "📊 Synchronization Report"
    log_info "==================================="
    log_info "Source  : $SOURCE_REPO"
    log_info "Target  : $TARGET_REPO"
    log_info "Mode    : $SYNC_MODE"
    log_info "Language: $LANGUAGE"
    log_info "Dry run : $DRY_RUN"
    log_info "==================================="
}

# Main execution
main() {
    parse_args "$@"
    
    # Validate inputs
    if [[ -z "$SOURCE_REPO" ]] || [[ -z "$TARGET_REPO" ]]; then
        log_error "Missing required arguments"
        show_usage
        exit 1
    fi
    
    if ! validate_sync_mode "$SYNC_MODE"; then
        exit 1
    fi
    
    if ! validate_language "$LANGUAGE"; then
        exit 1
    fi
    
    echo ""
    log_info "🔄 Synchronizing LexOrbital Documentation"
    echo ""
    
    validate_repos
    
    case "$SYNC_MODE" in
        structure)
            sync_structure
            ;;
        content)
            sync_structure
            sync_templates
            ;;
        full)
            sync_structure
            sync_templates
            create_placeholders
            ;;
        *)
            log_error "Invalid sync mode: $SYNC_MODE"
            exit 1
            ;;
    esac
    
    validate_structure
    
    echo ""
    generate_report
    echo ""
    log_info "🎉 Synchronization completed!"
    echo ""
}

main "$@"

