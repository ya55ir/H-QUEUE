# H-Queue — Design Reference (source de vérité front)

> But : Toute génération de code front DOIT respecter ces tokens et composants. Stack cible : Bootstrap + ERB, mobile-first.

---

## 1. Couleurs (tokens)

> Source de vérité en code : `app/assets/stylesheets/config/_colors.scss` (branché sur Bootstrap dans `_bootstrap_variables.scss`).

| Token SCSS | Hex | Cible Bootstrap / usage front | Usage |
|---|---|---|---|
| `$brand` | `#16324D` | `$dark` → `.bg-dark` / `.text-bg-dark` | Navy : navbar, footer, **texte principal** |
| `$primary` | `#F08424` | `$primary` → `.btn-primary` / `.text-primary` | Orange : CTA, counter, accents |
| `$secondary` | `#5A6B7C` | `$secondary` → `.text-secondary` | **Texte secondaire (muted)** / sous-titres |
| `$tertiary` | `#8A97A5` | `.text-body-tertiary` | Texte tertiaire / captions |
| `$background` | `#FDFBF3` | `$body-bg` → `.bg-body` | Fond des écrans |
| `$white` | `#FFFFFF` | `.bg-white` | Fond des inputs, cartes et boutons |
| `$success` | `#0F6E56` | `$success` → `.text-success` | État "table libre" |
| `$text-on-brand` | `#FDFBF3` | couleur de texte (pas une var Bootstrap) | Écrire sur un fond brand |
| `$brand-subtle` | `rgba(#16324D, .16)` | fond de badge | Badges (variante brand) |
| `$primary-subtle` | `rgba(#F08424, .16)` | fond de badge | Badges (variante primary) |
| `$success-subtle` | `rgba(#0F6E56, .16)` | fond de badge | Badges (variante success) |
| `$border` | `#EAE5D6` | `$border-color` → `.border` | Contours |

**Couleurs de texte (résumé) :** principal = `$brand` `#16324D` (= `$body-color`) · secondaire/muted = `$secondary` `#5A6B7C` · tertiaire/caption = `$tertiary` `#8A97A5`. Pas de token `text` / `text-muted` distinct : on réutilise `$brand` / `$secondary`.

---

## 2. Typographie

> Source de vérité en code : `config/_fonts.scss` + `_bootstrap_variables.scss`.

Polices : **titres** = `Baloo 2` (`$headers-font`) · **body** = `Nunito` (`$body-font`). Chargées via Google Fonts.

| Rôle | Taille | Weight | Line-height | Police |
|---|---|---|---|---|
| H1 / titre écran | `1.75rem` (28px) | 700 | 1.15 | Baloo 2 |
| H2 / sous-titre | `1.25rem` (20px) | 700 | 1.15 | Baloo 2 |
| H3 | `1rem` (16px) | 700 | 1.15 | Baloo 2 |
| Body | `1rem` (16px) | 600 (SemiBold) | 1.4 | Nunito |
| Counter / logo | — | 800 (ExtraBold) | — | Baloo 2 |

Weights dispo : Baloo 2 (400/500/600/700/800), Nunito (400/600/700).

---

## 3. Espacements & rayons

Échelle de spacing (px) : `xs: 8 · sm: 16 · md: 24 · xl: 48`

| Élément | Border-radius | Var SCSS |
|---|---|---|
| Bouton | pill (`50rem`) | `$btn-border-radius` |
| Input | pill (`50rem`) | `$input-border-radius` |
| Carte | 16px (`1rem`) | `$card-border-radius` / `$border-radius-lg` |
| Badge / pill | pill | — |
| Base (alerts, dropdowns) | 8px (`.5rem`) | `$border-radius` |

---

## 4. Composants clés

> **Référence vivante en code** : `app/views/pages/style_guide.html.erb` rend tous les composants ci-dessous. À consulter/mettre à jour en priorité. SCSS dans `app/assets/stylesheets/components/`.
> Icônes : Font Awesome (`fa-solid …`). Typo des composants "forts" (btn, badge, label, counter, logo) = **Baloo 2** ; texte courant = Nunito.

### Boutons (`_button.scss`)
Padding `1rem 1.5rem` (~56px de haut), forme pill, Baloo 2 bold. Icône optionnelle à gauche (`.btn i`).

| Variante | Classe | Rendu |
|---|---|---|
| Primaire | `.btn .btn-primary` | Fond orange, texte crème (`$text-on-brand`). CTA principal |
| Secondaire | `.btn .btn-outline-brand` | Fond blanc, bordure + texte navy ; hover → fond navy |
| Lien | `.btn .btn-link` | Texte navy sans soulignement ; hover → orange |

```erb
<button class="btn btn-primary">Join the virtual queue</button>
<button class="btn btn-outline-brand">See other venues</button>
```

### Formulaire (`_form.scss`)
- **Label** `.form-label` : Baloo bold, MAJUSCULES, navy, 14px.
- **Input** `.form-control` : pill, bordure `$border`, texte navy, placeholder `$tertiary`. Focus/`.is-active` → bordure orange + halo `$primary-subtle`.
- **Champ à icônes** : wrapper `.field-control` + `.field-icon .field-icon-left` / `.field-icon-right` (l'icône droite est orange, cliquable — ex. clear).

```erb
<div class="field-control">
  <i class="fa-solid fa-magnifying-glass field-icon field-icon-left"></i>
  <input type="text" class="form-control" placeholder="75017 Paris">
  <i class="fa-solid fa-location-crosshairs field-icon field-icon-right"></i>
</div>
```

### Venue card (`_venue_card.scss`, partial `shared/_venue_card`)
Carte horizontale : image 96px à gauche (collée haut/bas), corps à droite (padding `8px 12px`). Contient : `.venue-card-name` (h3, 16px), `.venue-card-distance` (13px, `$secondary`, non wrappé), badge cuisine, caption temps d'attente.

```erb
<%= render "shared/venue_card", venue: venue, distance: "0.5" %>
```

### Badge cuisine (`_badge.scss`)
`.badge-cuisine` : pill orange-subtle (fond `$primary-subtle`, texte `$primary`), Baloo bold 13px. Ex. `French`, `Italian`.

### Badge de statut de file (waiting / table-ready / no-show)
⚠️ **Pas encore implémenté** dans le code. Convention à suivre quand vous le créez, sur le modèle de `.badge-cuisine` (pill subtle) :
- `waiting` → variante brand : fond `$brand-subtle`, texte `$brand`
- `table-ready` → variante success : fond `$success-subtle`, texte `$success`
- `no-show` → à définir (pas de token danger en base — créer `$danger` si besoin)

### Counter (`_counter.scss`, partial `shared/_counter`)
`.counter` : gros chiffre orange, Baloo ExtraBold 64px. "people ahead of you".

```erb
<%= render "shared/counter", count: 12, wait: 10 %>
```

### Navbar (`_navbar.scss`, partial `shared/navbar`)
`.navbar-hqueue` : fond navy, `space-between`, liens crème. Logo `.logo` (`.logo-h` crème + `.logo-q` orange).

### Footer (`_footer.scss`, partial `shared/footer`)
`.footer` : barre 48px, fond navy, texte crème, centré.

### Divers
- **Card** (`_card.scss`) : bordure `$border` + ombre légère `0 2px 8px rgba($brand,.04)`, radius 16.
- **Caption** (`_caption.scss`) : `.caption` texte tertiaire 13px.
- **Avatar** (`_avatar.scss`) : `.avatar` (40px rond), `.avatar-large` (56px), `.avatar-bordered`, `.avatar-square`.
- **Page** (`_page.scss`) : `.page` gouttières globales `24px 24px 48px` (appliqué au `<main>`).
- **Alert** (`_alert.scss`) : toast fixe en bas à droite (`bottom/right 16px`).
- **Page title** : partial `shared/page_title` (locals `title`, `subtitle`).

---

## 5. Règles de génération (pour Claude)

- Toujours réutiliser les tokens ci-dessus, jamais de valeur en dur inventée.
- Mobile-first : concevoir pour ~375px de large d'abord.
- Réutiliser les classes/utilities Bootstrap plutôt que du CSS custom.
- Si une valeur manque ici, demander avant d'inventer.