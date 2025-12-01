# LexOrbital Template Documentation

> **Template de documentation standardisé** pour tous les repositories de l'écosystème LexOrbital.

## 🎯 Objectif

Ce repository fournit une **structure documentaire canonique** réutilisable dans tous les projets LexOrbital, garantissant :

- ✅ **Cohérence** : même structure, mêmes conventions
- ✅ **Qualité** : documentation professionnelle et complète
- ✅ **Réutilisabilité** : templates adaptables à tout type de module
- ✅ **Maintenabilité** : synchronisation facilitée entre repos

## 📦 Contenu du Template

### Structure Documentaire

```
template/
├── README-root.template.md       # Template README racine
├── docs/                          # Structure /docs complète
│   ├── index.template.md         # Hub de navigation
│   ├── project/                  # Vue d'ensemble projet
│   ├── architecture/             # Architecture technique
│   ├── compliance/               # Conformité (RGPD, sécurité)
│   ├── operations/               # Guides opérationnels
│   ├── security/                 # Documentation sécurité
│   ├── howto/                    # Guides pratiques
│   ├── reference/                # Références techniques
│   └── template/                 # Meta-documentation
└── scripts/                       # Scripts d'automatisation
```

### Scripts d'Automatisation

- `sync-docs-template.sh` - Synchronise la structure entre repos
- `init-docs.sh` - Initialise la documentation dans un nouveau repo
- `validate-docs.sh` - Valide la structure et la qualité

## 🚀 Utilisation

### 1. Initialiser la documentation dans un nouveau repo

```bash
cd lexorbital-template-docs
./scripts/init-docs.sh \
  --target ../lexorbital-module-xyz \
  --type infra \
  --language fr
```

### 2. Synchroniser la structure avec un repo existant

```bash
./scripts/sync-docs-template.sh \
  --source . \
  --target ../lexorbital-module-server \
  --mode structure \
  --dry-run
```

### 3. Valider la documentation d'un repo

```bash
./scripts/validate-docs.sh --target ../lexorbital-module-server
```

## 📋 Principes de la Structure

### Sans Numérotation

❌ **Éviter :** `01-installation.md`, `02-deployment.md`  
✅ **Préférer :** `installation.md`, `deployment.md`

**Pourquoi ?** La numérotation crée de la rigidité et rend les renommages difficiles. La navigation se fait par un `index.md` bien structuré.

### Organisation Sémantique

Les dossiers sont organisés par **type de contenu** :

- `project/` - Vision, stratégie, décisions
- `architecture/` - Design technique, diagrammes
- `compliance/` - Conformité légale et standards
- `operations/` - Guides déploiement et maintenance
- `security/` - Sécurité et durcissement
- `howto/` - Tutoriels pratiques
- `reference/` - Documentation de référence

### Navigation par Persona

Le fichier `docs/index.md` organise la navigation par profil utilisateur :

- 👨‍💼 **Décideurs / Recruteurs** → Vue d'ensemble, architecture, conformité
- 👨‍💻 **Développeurs** → Setup, contribution, troubleshooting
- 🔧 **DevOps / SysAdmins** → Installation, déploiement, maintenance
- 🔒 **Sécurité / Compliance** → Audits, standards, RGPD

## 📖 Documentation du Template

- [Guide de style](./template/docs/template/style-guide.md)
- [Structure documentaire](./template/docs/template/docs-structure.md)
- [Exemples d'adaptation](./docs/examples.md)

## 🔄 Synchronisation Multi-Repo

Ce template peut être synchronisé avec plusieurs repos via :

1. **Git subtree** (recommandé pour contenu figé)
2. **Scripts de sync** (recommandé pour structure évolutive)

Voir la [documentation de synchronisation](./docs/synchronization.md) pour plus de détails.

## 🎯 Repositories Utilisant ce Template

- [lexorbital-module-server](https://github.com/YohanGH/lexorbital-module-server) - Module infrastructure serveur
- [lexorbital-core](https://github.com/YohanGH/lexorbital-core) - Meta-Kernel LexOrbital
- [lexorbital-module-ui-kit](https://github.com/YohanGH/lexorbital-module-ui-kit) - Kit UI LexOrbital

## 🤝 Contribution

Pour contribuer au template :

1. **Respecter les conventions** définies dans le style guide
2. **Tester les changements** sur au moins 2 repos
3. **Documenter les modifications** dans le CHANGELOG
4. **Créer une PR** avec description claire

Voir [CONTRIBUTING.md](./CONTRIBUTING.md) pour les détails.

## 📄 License

[MIT](./LICENSE)

---

**Version :** 1.0.0  
**Dernière mise à jour :** 2025-12-01

