import { Controller } from "@hotwired/stimulus"

// Pilote le champ de recherche des venues.
// - submit : soumet le formulaire à la frappe avec un debounce de 300ms,
//   la réponse remplace le turbo-frame "venues_results" sans reload.
// - toggleClearButton : affiche le bouton clear dès qu'il y a du contenu dans le champ.
// - clearQuery : vide le champ et relance la recherche immédiatement.
export default class extends Controller {
  static targets = ["input", "clearButton"]

  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 300)
  }

  toggleClearButton() {
    this.clearButtonTarget.classList.toggle("d-none", this.inputTarget.value === "")
  }

  clearQuery() {
    clearTimeout(this.timeout)
    this.inputTarget.value = ""
    this.clearButtonTarget.classList.add("d-none")
    this.inputTarget.focus()
    this.element.requestSubmit()
  }
}
