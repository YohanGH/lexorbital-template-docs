# Bilingual Documentation Guide

> **Quick reference** for managing bilingual documentation (FR/EN).

---

## 🌍 Language Strategy

**🇫🇷 French:** Complete technical documentation (source of truth)  
**🇬🇧 English:** Professional showcase (overview, architecture, GDPR)

---

## 📋 What to Translate

### Priority 1 - Always (Showcase)

- ✅ `README.md` (root)
- ✅ `en/index.md`
- ✅ `en/project/overview.md`
- ✅ `en/architecture/system-design.md`
- ✅ `en/compliance/gdpr-overview.md`

**Time:** 4-6 hours | **ROI:** HUGE

### Priority 2 - Recommended

- `en/operations/quickstart.md`
- `en/howto/contribute.md`

**Time:** 2-3 hours | **ROI:** High

### Keep French-Only

- Detailed operational guides
- Complete compliance documentation
- Security procedures
- Scripts and technical references

---

## 🔄 Workflow

1. **Write in French first** (complete)
2. **Translate Priority 1** if showcase repo
3. **Link to French** for detailed docs

---

## 📖 Cross-Language Links

**From EN pages:**
```markdown
For complete documentation, see the [French version](../fr/operations/deployment.md) 🇫🇷
```

**From FR pages:**
```markdown
[English version available](../en/project/overview.md) 🇬🇧
```

---

## ✅ Quick Checklist

- [ ] French docs complete
- [ ] 5 showcase pages translated (P1)
- [ ] Bilingual README
- [ ] Cross-language links work
- [ ] Both indexes exist

---

For complete i18n strategy, see: [🇫🇷 Stratégie i18n](../../fr/template/i18n-strategy.md)

---

**Last updated:** 2025-12-01

