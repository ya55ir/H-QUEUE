import { Controller } from "@hotwired/stimulus"

// Affiche la bannière d'installation PWA uniquement sur iPhone/iPad,
// et seulement si l'app n'est pas déjà installée (iOS n'a pas de
// prompt d'installation natif contrairement à Android/Chrome).
export default class extends Controller {
  connect() {
    const isIOS = /iPhone|iPad|iPod/i.test(navigator.userAgent)
    const isStandalone = navigator.standalone === true

    if (isIOS && !isStandalone) {
      this.element.classList.remove("d-none")
    }
  }
}
