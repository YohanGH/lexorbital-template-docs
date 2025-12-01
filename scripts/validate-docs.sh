#!/usr/bin/env bash
# ============================================================================
# validate-docs.sh
# Validate the structure and quality of the documentation
# ============================================================================
# Usage examples:
#   ./validate-docs.sh --target ../lexorbital-module-server
# ============================================================================

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_REPO=""
CHECK_LINKS=true
CHECK_STRUCTURE=true
CHECK_STYLE=true
VERBOSE=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
ERRORS=0
WARNINGS=0
INFO=0

# Logging functions
log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    ERRORS=$((ERRORS + 1))
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    WARNINGS=$((WARNINGS + 1))
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
    INFO=$((INFO + 1))
}

log_debug() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${BLUE}[DEBUG]${NC} $1"
    fi
}

# Validate path format (prevent path traversal)
validate_path() {
    local path="$1"
    
    # Allow relative paths with .. (they will be resolved later)
    # Only check for obvious system directory targeting
    if [[ "$path" =~ ^/(bin|sbin|usr|etc|var|sys|proc|dev|boot|lib|opt|root) ]]; then
        log_error "Invalid path: path appears to target system directory: '$path'"
        return 1
    fi
    
    return 0
}

# Parse arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --target)
                TARGET_REPO="$2"
                shift 2
                ;;
            --no-links)
                CHECK_LINKS=false
                shift
                ;;
            --no-structure)
                CHECK_STRUCTURE=false
                shift
                ;;
            --no-style)
                CHECK_STYLE=false
                shift
                ;;
            --verbose)
                VERBOSE=true
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

Validate the structure and quality of the documentation.

Options:
    --target TARGET_REPO    Path to the repository to validate
    --no-links              Disable link validation
    --no-structure          Disable structure validation
    --no-style              Disable style validation
    --verbose               Verbose mode
    --help                  Show this help message

Examples:
    # Full validation
    $0 --target ../lexorbital-module-server

    # Validation without links
    $0 --target ../lexorbital-core --no-links

    # Verbose mode
    $0 --target ../lexorbital-module-ui-kit --verbose
EOF
}

# Validate repository exists
validate_repo() {
    log_debug "Validating repository: $TARGET_REPO"
    
    # Validate path format
    if ! validate_path "$TARGET_REPO"; then
        exit 1
    fi
    
    # Resolve absolute path first
    local resolved_path
    if [[ -d "$TARGET_REPO" ]]; then
        resolved_path=$(cd "$TARGET_REPO" && pwd) || {
            log_error "Failed to resolve absolute path: $TARGET_REPO"
            exit 1
        }
    else
        log_error "Repository not found: $TARGET_REPO"
        exit 1
    fi
    
    # Check if user passed docs directory directly
    if [[ "$(basename "$resolved_path")" == "docs" ]]; then
        # User passed docs directory, get parent repository
        resolved_path=$(dirname "$resolved_path")
        log_debug "Detected docs directory, using parent repository: $resolved_path"
    fi
    
    TARGET_REPO="$resolved_path"
    
    # Verify docs directory exists
    if [[ ! -d "$TARGET_REPO/docs" ]]; then
        log_error "docs/ directory not found in $TARGET_REPO"
        exit 1
    fi
    
    log_debug "✅ Repository validated: $TARGET_REPO"
}

# Check documentation structure
check_structure() {
    if [[ "$CHECK_STRUCTURE" == false ]]; then
        return 0
    fi
    
    echo ""
    log_info "🔍 Validating structure..."
    echo ""
    
    local docs_dir="$TARGET_REPO/docs"
    
    # Required directories
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
        # Check both fr and en
        local found=false
        if [[ -d "$docs_dir/fr/$dir" ]] || [[ -d "$docs_dir/en/$dir" ]]; then
            found=true
        fi
        
        if [[ "$found" == true ]]; then
            log_debug "✅ Directory present: $dir"
        else
            log_warn "Missing directory: $dir"
        fi
    done
    
    # Check for index.md
    if [[ -f "$docs_dir/fr/index.md" ]] || [[ -f "$docs_dir/en/index.md" ]]; then
        log_debug "✅ index.md file present"
    else
        log_error "index.md file missing (required)"
    fi
    
    # Check for numbered files (anti-pattern)
    local numbered_files=$(find "$docs_dir" -type f -name "[0-9][0-9]-*.md" 2>/dev/null || true)
    if [[ -n "$numbered_files" ]]; then
        log_warn "❌ Numbered files detected (anti-pattern):"
        echo "$numbered_files" | while IFS= read -r file; do
            [[ -n "$file" ]] && log_warn "  - $(basename "$file")"
        done
    else
        log_debug "✅ No numbered files detected"
    fi
    
    # Check for orphaned README files
    local readme_files=$(find "$docs_dir" -type f -name "README.md" 2>/dev/null || true)
    if [[ -n "$readme_files" ]]; then
        log_warn "⚠️  Orphaned READMEs detected (should be migrated):"
        echo "$readme_files" | while IFS= read -r file; do
            [[ -n "$file" ]] && log_warn "  - ${file#$docs_dir/}"
        done
    else
        log_debug "✅ No orphaned READMEs detected"
    fi
    
    echo ""
}

# Check internal links (using portable grep, not Perl regex)
check_links() {
    if [[ "$CHECK_LINKS" == false ]]; then
        return 0
    fi
    
    echo ""
    log_info "🔗 Validating internal links..."
    echo ""
    
    local docs_dir="$TARGET_REPO/docs"
    local broken_links=0
    local temp_file=$(mktemp)
    
    # Find all markdown files and check links
    find "$docs_dir" -type f -name "*.md" -print0 | while IFS= read -r -d '' file; do
        [[ ! -f "$file" ]] && continue
        
        log_debug "Checking links in: ${file#$docs_dir/}"
        
        # Extract markdown links using portable grep (not Perl regex)
        # Pattern: [text](path) - extract the path part
        grep -oE '\[.*?\]\([^)]+\)' "$file" 2>/dev/null | sed 's/.*(\(.*\))/\1/' | while IFS= read -r link; do
            [[ -z "$link" ]] && continue
            
            # Skip external links
            if [[ "$link" =~ ^https?:// ]]; then
                continue
            fi
            
            # Skip anchors only
            if [[ "$link" =~ ^# ]]; then
                continue
            fi
            
            # Resolve relative path
            local file_dir=$(dirname "$file")
            local link_without_anchor="${link%%#*}"
            
            # Get repo root directory
            local repo_root=$(dirname "$docs_dir")
            
            # List of allowed files at repo root
            local allowed_root_files=("CONTRIBUTING.md" "LICENSE" "CODE_OF_CONDUCT.md" "README.md" "SECURITY.md" "SUPPORT.md" "CHANGELOG.md")
            
            # Check if link points to allowed root file
            local is_allowed_root_file=false
            local link_basename=$(basename "$link_without_anchor" 2>/dev/null || echo "")
            for allowed_file in "${allowed_root_files[@]}"; do
                if [[ "$link_without_anchor" == "../$allowed_file" ]] || [[ "$link_without_anchor" == "../../$allowed_file" ]] || [[ "$link_basename" == "$allowed_file" ]]; then
                    # Check if file exists at repo root
                    if [[ -f "$repo_root/$allowed_file" ]]; then
                        is_allowed_root_file=true
                        break
                    fi
                fi
            done
            
            # If it's an allowed root file, skip further checks
            if [[ "$is_allowed_root_file" == true ]]; then
                continue
            fi
            
            # Check if it's a directory link (ends with /)
            if [[ "$link_without_anchor" =~ /$ ]]; then
                # Remove trailing slash for path resolution
                local dir_path="$file_dir/${link_without_anchor%/}"
                dir_path="${dir_path%%#*}"
                # Try to resolve as directory
                if [[ -d "$dir_path" ]] || [[ -f "$dir_path/index.md" ]]; then
                    # Valid directory link
                    continue
                fi
                # Try normalized path
                local normalized_path
                if normalized_path=$(cd "$file_dir" 2>/dev/null && realpath "${link_without_anchor%/}" 2>/dev/null); then
                    if [[ -d "$normalized_path" ]] || [[ -f "$normalized_path/index.md" ]]; then
                        continue
                    fi
                fi
            fi
            
            # Resolve target path
            local target_path="$file_dir/$link_without_anchor"
            
            # Normalize path (remove .. and .)
            local normalized_path
            if normalized_path=$(cd "$file_dir" 2>/dev/null && realpath "$link_without_anchor" 2>/dev/null); then
                target_path="$normalized_path"
            fi
            
            # Validate path stays within docs directory
            if [[ "$target_path" != "$docs_dir"* ]]; then
                log_error "Link escapes docs directory in ${file#$docs_dir/}: $link"
                echo "1" >> "$temp_file"
                continue
            fi
            
            # Check if target exists (file or directory)
            if [[ ! -f "$target_path" ]] && [[ ! -d "$target_path" ]]; then
                log_error "Broken link in ${file#$docs_dir/}: $link"
                echo "1" >> "$temp_file"
            fi
        done
    done
    
    # Count broken links from temp file
    if [[ -f "$temp_file" ]]; then
        broken_links=$(wc -l < "$temp_file" | tr -d ' ')
        rm -f "$temp_file"
    fi
    
    if [[ $broken_links -eq 0 ]]; then
        log_info "✅ All internal links are valid"
    else
        log_error "❌ $broken_links broken link(s) detected"
    fi
    
    echo ""
}

# Check markdown style
check_style() {
    if [[ "$CHECK_STYLE" == false ]]; then
        return 0
    fi
    
    echo ""
    log_info "📝 Validating Markdown style..."
    echo ""
    
    local docs_dir="$TARGET_REPO/docs"
    local files_without_date=0
    
    # Check for multiple H1 in same file (excluding code blocks)
    find "$docs_dir" -type f -name "*.md" -print0 | while IFS= read -r -d '' file; do
        [[ ! -f "$file" ]] && continue
        
        # Extract content outside code blocks and count H1
        local in_code_block=false
        local h1_count=0
        
        while IFS= read -r line || [[ -n "$line" ]]; do
            # Check if line starts/ends a code block
            if [[ "$line" =~ ^\`\`\` ]]; then
                if [[ "$in_code_block" == false ]]; then
                    in_code_block=true
                else
                    in_code_block=false
                fi
                continue
            fi
            
            # Only count H1 outside code blocks (H1 is # followed by space and text, not ##)
            if [[ "$in_code_block" == false ]] && [[ "$line" =~ ^#\ [^#] ]]; then
                h1_count=$((h1_count + 1))
            fi
        done < "$file"
        
        if [[ $h1_count -gt 1 ]]; then
            log_warn "Multiple H1 in ${file#$docs_dir/} ($h1_count found)"
        fi
    done
    
    # Check for TODO markers
    local todo_count=$(grep -r "TODO:" "$docs_dir" 2>/dev/null | wc -l | tr -d ' \n' || echo "0")
    todo_count=$((todo_count + 0))  # Convert to integer, default to 0 if empty
    if [[ $todo_count -gt 0 ]]; then
        log_info "ℹ️  $todo_count TODO(s) detected in documentation"
    fi
    
    # Check for last update dates (use wc -l instead of variable increment in subshell)
    local files_without_date=$(find "$docs_dir" -type f -name "*.md" -exec sh -c 'for f; do grep -q "Last updated\|Dernière mise à jour" "$f" 2>/dev/null || echo "$f"; done' _ {} + 2>/dev/null | wc -l | tr -d ' \n' || echo "0")
    files_without_date=$((files_without_date + 0))  # Convert to integer, default to 0 if empty
    
    if [[ $files_without_date -gt 0 ]]; then
        log_info "ℹ️  $files_without_date file(s) without update date"
    fi
    
    echo ""
}

# Check for secrets or sensitive data
check_secrets() {
    echo ""
    log_info "🔐 Checking for secrets/sensitive data..."
    echo ""
    
    local docs_dir="$TARGET_REPO/docs"
    local secrets_found=false
    
    # Patterns to check (more specific to reduce false positives)
    local patterns=(
        "password[[:space:]]*=[[:space:]]*['\"]?[a-zA-Z0-9]{8,}"
        "api[_-]?key[[:space:]]*=[[:space:]]*['\"]?[a-zA-Z0-9]{16,}"
        "secret[[:space:]]*=[[:space:]]*['\"]?[a-zA-Z0-9]{16,}"
        "token[[:space:]]*=[[:space:]]*['\"]?[a-zA-Z0-9]{16,}"
        "sk_live_[a-zA-Z0-9]{24,}"
        "pk_live_[a-zA-Z0-9]{24,}"
    )
    
    for pattern in "${patterns[@]}"; do
        local matches=$(grep -riE "$pattern" "$docs_dir" 2>/dev/null || true)
        if [[ -n "$matches" ]]; then
            # Filter out false positives (examples, placeholders)
            echo "$matches" | grep -v "TODO\|EXAMPLE\|PLACEHOLDER\|password.*=.*\*\*\*" > /dev/null 2>&1 && {
                log_error "⚠️  Possible secret detected (pattern: $pattern)"
                secrets_found=true
            }
        fi
    done
    
    if [[ "$secrets_found" == false ]]; then
        log_info "✅ No obvious secrets detected"
    fi
    
    echo ""
}

# Generate validation report
generate_report() {
    echo ""
    log_info "==================================="
    log_info "📊 Validation Report"
    log_info "==================================="
    log_info "Repository : $TARGET_REPO"
    log_info ""
    
    if [[ $ERRORS -gt 0 ]]; then
        echo -e "${RED}❌ Errors    : $ERRORS${NC}"
    else
        echo -e "${GREEN}✅ Errors    : 0${NC}"
    fi
    
    if [[ $WARNINGS -gt 0 ]]; then
        echo -e "${YELLOW}⚠️  Warnings   : $WARNINGS${NC}"
    else
        echo -e "${GREEN}✅ Warnings   : 0${NC}"
    fi
    
    echo -e "${BLUE}ℹ️  Info      : $INFO${NC}"
    
    log_info "==================================="
    echo ""
    
    if [[ $ERRORS -gt 0 ]]; then
        log_error "❌ Validation failed"
        return 1
    elif [[ $WARNINGS -gt 0 ]]; then
        log_warn "⚠️  Validation succeeded with warnings"
        return 0
    else
        log_info "✅ Validation succeeded!"
        return 0
    fi
}

# Main execution
main() {
    parse_args "$@"
    
    if [[ -z "$TARGET_REPO" ]]; then
        log_error "Target repository required"
        show_usage
        exit 1
    fi

    echo ""
    log_info "🔍 Validating LexOrbital Documentation"
    echo ""

    log_debug "Calling validate_repo with TARGET_REPO=$TARGET_REPO"
    validate_repo || { log_error "validate_repo failed"; exit 1; }
    log_debug "validate_repo completed"

    check_structure
    check_links
    check_style
    check_secrets

    generate_report
    exit_code=$?
    
    exit $exit_code
}

main "$@"
