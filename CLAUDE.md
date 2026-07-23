# H-Queue — Instructions projet

File d'attente virtuelle pour bars/restaurants. Stack : Rails 8, PostgreSQL, Hotwire/Stimulus, ERB, Bootstrap 5.3, Twilio, Devise. Mobile-first, app en anglais. Équipe junior → solutions simples et lisibles.

## Front-end : anti-hallucination (IMPÉRATIF)

Avant d'écrire ou modifier du code front (ERB, SCSS, classes CSS) :

1. **Lire les tokens** dans `app/assets/stylesheets/config/` : `_colors.scss`, `_fonts.scss`, `_bootstrap_variables.scss`. C'est la source de vérité.
2. **Lire `design.md`** (racine) : résumé lisible des tokens + inventaire des composants.
3. **Réutiliser les composants existants** vus dans `app/views/pages/style_guide.html.erb` et `app/assets/stylesheets/components/`. Ne pas réinventer un bouton/carte/badge qui existe déjà.

Règles :
- Jamais de valeur en dur (hex, px, radius) inventée. Utiliser les variables SCSS (`$brand`, `$primary`, `$border`…) ou les utilities Bootstrap.
- Privilégier les utilities/classes Bootstrap au CSS custom.
- Si un token ou composant manque, le signaler et demander avant d'inventer.
- Tout nouveau composant : l'ajouter au `style_guide.html.erb`.
- Mobile-first (~390px), zéro effort desktop.

## Workflow ticket → PR (Claude Code)

Le dev crée le ticket GitHub en amont et indique le **numéro ou nom du ticket** à traiter. Dérouler alors, sans sauter d'étape :

1. **Lire le ticket** : `gh issue view <num>` — titre, description, critères d'acceptation. Si le scope est ambigu, demander avant de coder.
2. **Repartir d'un master à jour** : `git checkout master && git pull origin master`.
3. **Créer la branche** : `feature/<slug>` (nouvelle feature) ou `fix/<slug>` (correctif), slug déduit du titre du ticket. `git checkout -b feature/<slug>`.
4. **Implémenter en silo** : model → migration → routes → controller → views → links → HTML/CSS. Respecter la section Front-end ci-dessus et les conventions Rails.
5. **Tester en local** : lancer `rails s` et vérifier la/les page(s) ; jouer les tests s'il y en a.
6. **Commits courts** en anglais, fréquents. Référencer le ticket (ex. `#12`).
7. **Push** : `git push -u origin feature/<slug>`.
8. **Ouvrir la PR** : `gh pr create --base master` — titre = intitulé du ticket, corps décrivant les changements + `Closes #<num>`.
9. **S'ARRÊTER À LA PR.** Ne jamais merger, ne jamais push sur `master`. Review + merge = Lead Dev.

Une branche = un ticket. Limiter les dépendances techniques entre tickets.

### Git selon l'environnement

- **Claude Code (terminal natif)** : exécute tout le workflow git ci-dessus (`checkout`, `commit`, `push`, `gh pr create`). Git tourne avec les droits du dev, RAS.
- **Cowork (repo monté)** : ne PAS lancer de commandes git d'écriture (`git add/commit/push/merge`) — le montage a des permissions restreintes et peut laisser un `.git/index.lock` orphelin. Se limiter à **éditer les fichiers** ; le dev committe/pousse depuis son terminal.
- **Déblocage `index.lock`** : si `fatal: Unable to create '.git/index.lock'` apparaît (aucun git réellement en cours), le retirer depuis le terminal du dev : `rm -f .git/index.lock`, puis relancer.

## Conventions Rails

- MVC, DRY, SRP. tables au pluriel, REST, `before_action`/`skip_before_action`.
- Nommage branches : `feature/xxx`, `fix/xxx`. Commits courts.
- Jamais de push direct sur `master` : toujours une PR, review + merge par le Lead Dev.
- Secrets dans `.env` (git ignore), `heroku config:set` en prod.
- Prévenir si une approche casse une convention Rails ou crée un risque pour la démo.

## Attentes de réponse

- Court et direct, sans enrobage.
- Sujets complexes (BDD, archi, Twilio, Devise, migrations) : détailler avec les étapes et le code.
- Toujours du code concret (Ruby/Rails/ERB) pour l'implémentation.
- Pour un model : montrer migration + model (associations + validations).
