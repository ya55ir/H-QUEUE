import { Controller } from "@hotwired/stimulus"

// Soumet le formulaire de recherche automatiquement à la frappe,
// avec un debounce pour éviter une requête par caractère tapé. On soumet la requête quand le user a terminé de saisir des caractères dans le champs de recherche, après un délai de 300ms.
// La réponse remplace le contenu du turbo-frame "venues_results" par les venues cards ou empty state, sans reload de la page.
export default class extends Controller {
  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 300)
  }
}