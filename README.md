# 🇫🇷 LexOrbital Template Documentation | 🇬🇧 Documentation Template

> **Standardized bilingual documentation template** for all repositories in the LexOrbital ecosystem.

---

## 🌍 Language / Langue

- 🇫🇷 **[Documentation Française (complète)](./README-FR.md)** - Documentation technique complète
- 🇬🇧 **English version below** - Professional showcase version

---

## 🎯 Objective

This repository provides a **canonical documentation structure** reusable across all LexOrbital projects, ensuring:

- ✅ **Consistency**: same structure, same conventions
- ✅ **Quality**: professional and complete documentation
- ✅ **Reusability**: templates adaptable to any type of module
- ✅ **Maintainability**: facilitated synchronization between repos
- ✅ **Multi-language**: French OR English structure

## 📦 Structure

### Documentation Organization

```
template/
├── README-root.template.md       # Root README template
├── docs/
│   ├── fr/                       # 🇫🇷 French documentation structure
│   │   ├── index.md
│   │   ├── project/
│   │   ├── architecture/
│   │   ├── compliance/
│   │   ├── operations/
│   │   ├── security/
│   │   ├── howto/
│   │   ├── reference/
│   │   └── template/
│   └── en/                       # 🇬🇧 English documentation structure
│       ├── index.md
│       ├── project/
│       ├── architecture/
│       ├── compliance/
│       ├── operations/
│       ├── security/
│       ├── howto/
│       └── reference/
└── scripts/                      # Automation scripts
```

### Language Strategy

**Choose ONE language per repository:**

**🇫🇷 French (`--language fr`):**
- For French legal/compliance context
- Complete technical documentation
- CNIL/ANSSI standards
- Example: infrastructure modules with French legal requirements

**🇬🇧 English (`--language en`):**
- For international projects
- Standard for UI/API modules
- Broader adoption
- Example: open-source libraries, UI kits

## 🚀 Usage

### 1. Initialize French documentation in a new repo

```bash
cd lexorbital-template-docs
./scripts/init-docs.sh \
  --target ../lexorbital-module-xyz \
  --type infra \
  --language fr
```

### 2. Initialize English documentation

```bash
./scripts/init-docs.sh \
  --target ../lexorbital-module-xyz \
  --type api \
  --language en
```

### 3. Synchronize structure with an existing repo

```bash
./scripts/sync-docs-template.sh \
  --source . \
  --target ../lexorbital-module-server \
  --mode content \
  --language fr
```

### 4. Validate documentation

```bash
./scripts/validate-docs.sh --target ../lexorbital-module-server
```

## 📋 Structure Principles

### Without Numbering

❌ **Avoid:** `01-installation.md`, `02-deployment.md`  
✅ **Prefer:** `installation.md`, `deployment.md`

**Why?** Numbering creates rigidity and makes renaming difficult. Navigation is done through a well-structured `index.md`.

### Semantic Organization

Folders are organized by **content type**:

- `project/` - Vision, strategy, decisions
- `architecture/` - Technical design, diagrams
- `compliance/` - Legal compliance and standards
- `operations/` - Deployment and maintenance guides
- `security/` - Security and hardening
- `howto/` - Practical tutorials
- `reference/` - Reference documentation

### Persona-Based Navigation

The `docs/{fr|en}/index.md` file organizes navigation by user profile:

- 👨‍💼 **Decision Makers / Recruiters** → Overview, architecture, compliance
- 👨‍💻 **Developers** → Setup, contribution, troubleshooting
- 🔧 **DevOps / SysAdmins** → Installation, deployment, maintenance
- 🔒 **Security / Compliance** → Audits, standards, GDPR

## 🌍 Which Language to Choose?

### French (`--language fr`)

**Use for:**
- Infrastructure modules with French legal context
- RGPD/CNIL compliance requirements
- Server/backend projects in French context

**Example repos:**
- lexorbital-module-server (French legal compliance)
- Backend services with CNIL requirements

### English (`--language en`)

**Use for:**
- UI/Frontend modules (international standard)
- API/Backend with international audience
- Open-source libraries
- CLI tools

**Example repos:**
- lexorbital-module-ui-kit (UI standard)
- API modules for international use

## 📖 Template Documentation

- [Style guide](./template/docs/fr/template/style-guide.md) 🇫🇷
- [Documentation structure](./template/docs/fr/template/docs-structure.md) 🇫🇷
- [Bilingual strategy](./docs/i18n-strategy.md) 🇫🇷🇬🇧

## 🔄 Multi-Repo Synchronization

This template can be synchronized with multiple repos via:

1. **Git subtree** (recommended for static content)
2. **Sync scripts** (recommended for evolving structure)

Scripts support:
- `--language fr` - French only (default)
- `--language en` - English only

## 🎯 Repositories Using This Template

- [lexorbital-module-server](https://github.com/YohanGH/lexorbital-module-server) 🇫🇷 - Server infrastructure module
- [lexorbital-core](https://github.com/YohanGH/lexorbital-core) 🇫🇷 - LexOrbital Meta-Kernel
- [lexorbital-module-ui-kit](https://github.com/YohanGH/lexorbital-module-ui-kit) 🇬🇧 - LexOrbital UI Kit

## 🤝 Contributing

To contribute to the template:

1. **Respect conventions** defined in the style guide
2. **Test changes** on at least 2 repos
3. **Document modifications** in the CHANGELOG
4. **Create a PR** with a clear description
5. **For translations:** Update both FR and EN if applicable

See [CONTRIBUTING.md](./CONTRIBUTING.md) for details.

## 📄 License

[MIT](./LICENSE)

---

**Version:** 1.0.0  
**Last updated:** 2025-12-01

---

<div align="center">

**Made with 🌍 by the LexOrbital community**

[🇫🇷 Docs FR](./template/docs/fr/) • [🇬🇧 Docs EN](./template/docs/en/) • [Contributing](./CONTRIBUTING.md)

</div>
