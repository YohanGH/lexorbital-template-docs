# Changelog

All notable changes to the LexOrbital Template Documentation will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-01

### Added

#### Bilingual Structure (FR/EN)
- ✨ **Major feature:** Bilingual documentation structure with `docs/fr/` and `docs/en/`
- 🇫🇷 French as source of truth (complete technical documentation)
- 🇬🇧 English as professional showcase (overview, architecture, GDPR)
- 📖 i18n strategy guide (`docs/i18n-strategy.md`)
- 🌍 Bilingual root README template
- 🗺️ Separate index templates for FR and EN

#### Scripts Enhancement
- 🔧 `init-docs.sh` now supports `--language fr|en|both`
- 🔄 `sync-docs-template.sh` supports `--language fr|en|both`
- ✅ `validate-docs.sh` validates bilingual structure

#### Templates
- 📝 Bilingual `README-root.template.md`
- 📋 French index template (`fr/index.template.md`)
- 📋 English index template (`en/index.template.md`)
- 🎨 Style guide adapted for bilingual docs

#### Documentation
- 📚 Complete i18n strategy documentation
- 🎯 Translation priorities (P1, P2, P3)
- 🔄 Bilingual workflow guidelines
- ✅ Bilingual migration checklist

### Changed
- 🔄 Structure from flat `docs/` to `docs/fr/` and `docs/en/`
- 📖 README emphasizes bilingual capabilities
- 🛠️ Scripts default to `--language en or fr` for new repos
- 📝 Templates include language switcher

### Rationale

**Why bilingual?**
- ✅ International professional visibility (recruitment)
- ✅ GDPR showcase in English (HUGE bonus for international credibility)
- ✅ Maintainable (French source, English showcase only)
- ✅ Realistic for small teams (no full translation needed)
- ✅ Scalable (progressive translation possible)

**Strategic approach:**
- Translate ONLY showcase pages (5 pages): overview, architecture, GDPR
- Keep technical depth in French (legal context, detailed guides)
- 4-6h initial investment for HUGE ROI

---

## [0.1.0] - 2025-11-30

### Added
- Initial release of lexorbital-template-docs
- Standard documentation structure
- `sync-docs-template.sh` script
- `init-docs.sh` script
- `validate-docs.sh` script
- Style guide
- Documentation structure guide

---

**Note:** This changelog is maintained in English as it's a technical reference document for the international developer community.
