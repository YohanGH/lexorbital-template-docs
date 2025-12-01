# Stratégie d'Internationalization (i18n)

> **Guide bilingue** pour la documentation LexOrbital : français (source) + anglais (vitrine).

---

## 🎯 Philosophie

**Stratégie pragmatique et maintenable :**
- 🇫🇷 **Français = Source de vérité** (documentation technique complète)
- 🇬🇧 **Anglais = Vitrine professionnelle** (overview, architecture, RGPD)

**Pourquoi cette approche ?**
- ✅ Réaliste pour petites équipes
- ✅ Visibilité internationale professionnelle
- ✅ Contexte légal français préservé
- ✅ Maintenable sans duplication excessive
- ✅ Scalable (traduction progressive possible)

---

## 📁 Structure Bilingue

```
docs/
├── fr/                           # 🇫🇷 Documentation complète (source)
│   ├── index.md
│   ├── project/
│   │   ├── overview.md          # Vision complète
│   │   ├── roadmap.md
│   │   ├── decisions.md
│   │   └── glossary.md
│   ├── architecture/
│   │   ├── system-design.md     # Architecture détaillée
│   │   ├── infrastructure.md
│   │   ├── network-topology.md
│   │   └── diagrams/
│   ├── compliance/
│   │   ├── overview.md          # Conformité complète
│   │   ├── gdpr-technical.md    # Article 32 détaillé
│   │   ├── security-standards.md
│   │   ├── logging-policy.md
│   │   └── data-retention.md
│   ├── operations/              # Guides opérationnels complets
│   ├── security/                # Documentation sécurité complète
│   ├── howto/                   # Guides pratiques
│   ├── reference/               # Références techniques
│   └── template/                # Meta-documentation
│
└── en/                           # 🇬🇧 Vitrine professionnelle (résumé)
    ├── index.md
    ├── project/
    │   └── overview.md          # ⭐ PRIORITÉ 1 (recrutement)
    ├── architecture/
    │   └── system-design.md     # ⭐ PRIORITÉ 1 (technique)
    ├── compliance/
    │   └── gdpr-overview.md     # ⭐ PRIORITÉ 1 (ÉNORME bonus!)
    └── operations/
        └── quickstart.md        # ⭐ PRIORITÉ 2 (démarrage rapide)
```

---

## 🌟 Priorités de Traduction

### Priorité 1 - Toujours Traduire (Vitrine Emploi)

**Ces pages sont essentielles pour la visibilité internationale :**

| Page | Objectif | Impact |
|------|----------|--------|
| `README.md` (root) | Premier contact | 🔥🔥🔥 |
| `en/index.md` | Navigation EN | 🔥🔥🔥 |
| `en/project/overview.md` | Vision du projet | 🔥🔥🔥 |
| `en/architecture/system-design.md` | Compétences techniques | 🔥🔥🔥 |
| `en/compliance/gdpr-overview.md` | Privacy by design | 🔥🔥🔥 |

**Temps de traduction estimé :** 4-6 heures  
**ROI :** ÉNORME (recrutement international, crédibilité professionnelle)

---

### Priorité 2 - Fortement Recommandé

**Valeur professionnelle ajoutée :**

| Page | Objectif | Impact |
|------|----------|--------|
| `en/operations/quickstart.md` | Démarrage rapide | 🔥🔥 |
| `en/howto/contribute.md` | Contribution open source | 🔥🔥 |
| `en/architecture/infrastructure.md` | Stack technique | 🔥 |

**Temps de traduction estimé :** 2-3 heures  
**ROI :** Élevé (facilite adoption internationale)

---

### Priorité 3 - Optionnel

**Nice-to-have mais pas critique :**

- Guides de sécurité (résumés)
- Références commandes (si API publique)
- Diagrammes avec légendes bilingues

**Temps de traduction estimé :** 3-5 heures  
**ROI :** Moyen

---

### À Garder en Français Uniquement

**Contexte légal français / Profondeur technique :**

- ✅ Guides opérationnels détaillés
- ✅ Documentation compliance CNIL complète
- ✅ Procédures de sécurité détaillées
- ✅ Scripts et références techniques
- ✅ Guides de maintenance
- ✅ Documentation Ansible détaillée

**Pourquoi ?**
- Contexte légal français (CNIL, ANSSI)
- Profondeur technique (détails opérationnels)
- Maintenance réaliste (évite duplication)

---

## 🔄 Workflow de Maintenance

### Règle Fondamentale

**🇫🇷 Français d'abord, toujours.**

1. Écrire/modifier la documentation en français
2. Si page prioritaire (P1/P2), traduire ensuite en anglais
3. Si page technique profonde, laisser en français uniquement

### Détection de Divergence

Script simple pour identifier pages FR sans équivalent EN :

```bash
# Lister pages FR sans équivalent EN
diff -qr docs/fr docs/en | grep "Only in docs/fr"
```

### Synchronisation

```bash
# Synchroniser structure bilingue
cd lexorbital-template-docs
./scripts/sync-docs-template.sh \
  --source . \
  --target ../lexorbital-module-xyz \
  --language both \
  --mode structure
```

### Indication de Traduction Manquante

Dans les pages EN, indiquer clairement les liens vers FR :

```markdown
For complete technical documentation, see the [French version](../fr/operations/deployment.md) 🇫🇷
```

---

## 🎨 Conventions Bilingues

### README Racine

Toujours bilingue avec sélection claire :

```markdown
# 🇫🇷 Nom du Projet | 🇬🇧 Project Name

## 🌍 Language / Langue

👉 **[Documentation FR (complète)](./docs/fr/index.md)**  
👉 **[Documentation EN (showcase)](./docs/en/index.md)**
```

### Index Pages

Toujours indiquer les langues disponibles :

```markdown
**🌍 Available languages:** [🇫🇷 Français](../fr/index.md) • [🇬🇧 English](../en/index.md)
```

### Liens Croisés

**Dans docs FR :**
```markdown
[Version anglaise disponible](../en/project/overview.md) 🇬🇧
```

**Dans docs EN :**
```markdown
[Complete French version](../fr/project/overview.md) 🇫🇷
```

---

## 📊 Métriques de Succès

### Indicateurs Quantitatifs

| Métrique | Objectif | Statut |
|----------|----------|--------|
| Pages priorité 1 traduites | 100% (5 pages) | À atteindre |
| Pages priorité 2 traduites | 70% (2-3 pages) | Optionnel |
| Temps de traduction total | < 10h | Raisonnable |

### Indicateurs Qualitatifs

- ✅ Recruteur international comprend projet en <5min (EN)
- ✅ Développeur francophone trouve tout en FR
- ✅ Documentation technique complète en FR
- ✅ Vitrine professionnelle convaincante en EN

---

## 🛠️ Outils Recommandés

### Traduction

**Option 1 - Traduction humaine (recommandé)**
- Qualité supérieure
- Contexte préservé
- Ton professionnel garanti

**Option 2 - Traduction assistée**
- DeepL (meilleure qualité que Google)
- ChatGPT pour révision
- **Toujours relire !**

### Gestion

**Scripts fournis :**
- `init-docs.sh --language both` - Initialisation bilingue
- `sync-docs-template.sh --language both` - Synchronisation
- `validate-docs.sh` - Validation structure

---

## 🚀 Mise en Œuvre

### Nouveau Repo

```bash
# 1. Créer structure bilingue
cd lexorbital-template-docs
./scripts/init-docs.sh \
  --target ../nouveau-module \
  --type infra \
  --language both

# 2. Écrire documentation FR (complète)
# 3. Traduire pages priorité 1 en EN (showcase)
# 4. Valider
./scripts/validate-docs.sh --target ../nouveau-module
```

### Repo Existant (Migration)

```bash
# 1. Créer structure /fr et /en
cd lexorbital-template-docs
./scripts/sync-docs-template.sh \
  --source . \
  --target ../repo-existant \
  --language both \
  --mode structure

# 2. Déplacer docs existantes vers /fr
mv ../repo-existant/docs/*.md ../repo-existant/docs/fr/

# 3. Créer pages showcase en /en (5 pages priorité 1)
# 4. Mettre à jour README racine (bilingue)
```

---

## 📖 Exemples

### Repos LexOrbital

- **lexorbital-core** 🇫🇷🇬🇧 - Bilingue (vitrine internationale)
- **lexorbital-module-server** 🇫🇷 - Français uniquement (contexte légal)
- **lexorbital-module-ui-kit** 🇬🇧 - Anglais uniquement (standard UI)
- **lexorbital-template-docs** 🇫🇷🇬🇧 - Bilingue (template)

### Choix de Langue par Type

| Type de Module | Langue Recommandée | Raison |
|----------------|-------------------|--------|
| Infrastructure (FR) | 🇫🇷 ou 🇫🇷🇬🇧 | Contexte légal CNIL/ANSSI |
| UI/Frontend | 🇬🇧 ou 🇫🇷🇬🇧 | Standard international |
| API/Backend | 🇬🇧 ou 🇫🇷🇬🇧 | Adoption internationale |
| CLI/Tooling | 🇬🇧 | Usage développeurs |

---

## ✅ Checklist Migration Bilingue

**Avant de passer en bilingue :**

- [ ] Documentation FR complète et à jour
- [ ] Identifier pages priorité 1 à traduire (5 pages)
- [ ] Planifier 4-6h pour traduction initiale
- [ ] Créer structure docs/fr et docs/en
- [ ] Migrer docs existantes vers docs/fr/
- [ ] Traduire 5 pages priorité 1
- [ ] Créer README racine bilingue
- [ ] Mettre à jour index.md (fr et en)
- [ ] Valider liens croisés
- [ ] Tester navigation bilingue
- [ ] Commit et déployer

---

## 🎯 Conclusion

**Cette stratégie bilingue est :**

✅ **Réaliste** - Pas de traduction exhaustive  
✅ **Maintenable** - FR source, EN vitrine  
✅ **Professionnelle** - Visibilité internationale  
✅ **Pragmatique** - ROI élevé pour effort minimal  
✅ **Scalable** - Traduction progressive possible

**Investissement initial :** 4-6h (5 pages priorité 1)  
**ROI :** ÉNORME (recrutement + crédibilité internationale)

---

**Dernière mise à jour :** 2025-12-01  
**Version :** 1.0.0

