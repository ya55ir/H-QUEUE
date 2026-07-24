import { Controller } from "@hotwired/stimulus"

// Pilote le champ de recherche des venues.
// Deux modes exclusifs : recherche texte OU géolocalisation du user.
// Cliquer le viseur vide le champ de recherche, et le readonly du mode
// géolocalisé empêche l'inverse.
// Un seul bouton visible à droite du champ : geo si le champ est vide, clear sinon.
export default class extends Controller {
  static targets = ["input", "clearButton", "geoButton", "searchIcon",
                    "latitude", "longitude", "error"]
  static values = { aroundYouLabel: String }

  // Frappe dans le champ de recherche : masque une erreur résiduelle, bascule les boutons
  // et relance la recherche.
  onInput() {
    this.hideError()
    this.toggleButtons()
    this.submit()
  }

  // Soumet le formulaire avec un debounce de 300ms : la réponse remplace le
  // turbo-frame "venues_results" sans recharger la page.
  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.element.requestSubmit(), 300)
  }

  // Clic sur le bouton de localisation. L'API n'existe pas hors contexte sécurisé (http://
  // autre que localhost), d'où le garde.
  locate() {
    if (!navigator.geolocation) {
      return this.showError("Geolocation is not available on this device.")
    }
    this.hideError()
    this.startLoading()
    navigator.geolocation.getCurrentPosition(
      (position) => this.onLocationSuccess(position),
      (error) => this.onLocationError(error),
      { enableHighAccuracy: false, timeout: 10000, maximumAge: 60000 }
    )
  }

  // Position obtenue : on vide le champ de recherche (les deux modes sont exclusifs)
  // et on pose les coordonnées dans les hidden fields lus par le controller.
  onLocationSuccess({ coords }) {
    this.stopLoading()
    this.inputTarget.value = ""
    this.latitudeTarget.value = coords.latitude
    this.longitudeTarget.value = coords.longitude
    // Le libellé est posé APRÈS la soumission : Turbo sérialise le formulaire
    // pendant requestSubmit(), on évite ainsi un query=Around+you dans l'URL.
    this.element.requestSubmit()
    this.showAroundYou()
  }

  // Gestion des erreurs de localisations avec message texte : 1 refus, 2 position indisponible, 3 timeout.
  onLocationError(error) {
    this.stopLoading()
    this.showError({
      1: "Location access denied. Enable it in your browser settings to see venues around you.",
      2: "We couldn't get your location. Try again or search by name.",
      3: "Locating took too long. Try again or search by name."
    }[error.code])
  }

  // Clic sur le bouton croix à droite du champ : vide le contenu du champ quel que soit le mode.
  clearQuery() {
    clearTimeout(this.timeout)
    const wasGeolocated = this.hasCoordinates
    this.resetField()
    // Pas de refocus en sortie de géoloc : évite de faire remonter le clavier mobile.
    if (!wasGeolocated) this.inputTarget.focus()
    this.element.requestSubmit()
  }

  // --- private ---

  // Sert à distinguer une sortie de géolocalisation d'une sortie de recherche texte.
  get hasCoordinates() {
    return this.latitudeTarget.value !== ""
  }

  // Un champ rempli signifie soit une recherche en cours, 
  // Soit le libellé "Around you" du mode géolocalisé : dans les deux cas, le button clear s'impose à droite du champ.
  get isActive() {
    return this.inputTarget.value !== ""
  }

  // Les deux boutons géolocalisation et clear occupent la même position, ils sont toujours en miroir : on affiche l'un ou l'autre selon l'état du champ de recherche.
  toggleButtons() {
    this.clearButtonTarget.classList.toggle("d-none", !this.isActive)
    this.geoButtonTarget.classList.toggle("d-none", this.isActive)
  }

  // Vide les hidden fields des coordonnées pour revenir à l'état initial de recherche texte.
  clearCoordinates() {
    this.latitudeTarget.value = ""
    this.longitudeTarget.value = ""
  }

  // Bascule le champ de recherche en état géolocalisation : pin à gauche, libellé around you figé et champ non éditable.
  showAroundYou() {
    this.inputTarget.value = this.capitalize(this.aroundYouLabelValue)
    this.inputTarget.readOnly = true
    this.inputTarget.classList.add("is-locked")
    this.searchIconTarget.classList.replace("fa-magnifying-glass", "fa-location-dot")
    this.toggleButtons()
  }

  // Retour à l'état initial : champ vide, éditable, loupe à gauche, sans coordonnées.
  resetField() {
    this.inputTarget.value = ""
    this.inputTarget.readOnly = false
    this.inputTarget.classList.remove("is-locked")
    this.searchIconTarget.classList.replace("fa-location-dot", "fa-magnifying-glass")
    this.clearCoordinates()
    this.toggleButtons()
  }

  // Capitalise la première lettre d'un texte.
  capitalize(text) {
    return text.charAt(0).toUpperCase() + text.slice(1)
  }

  // Début de l'animation de chargement du bouton de géolocalisation : on remplace l'icône par un spinner et on ajoute la classe CSS qui fait tourner le spinner.
  // `disabled` évite un double appel à getCurrentPosition.
  startLoading() {
    this.geoButtonTarget.classList.replace("fa-location-crosshairs", "fa-spinner")
    this.geoButtonTarget.classList.add("field-icon-spin")
    this.geoButtonTarget.disabled = true
  }

  // Fin de l'animation de chargement du bouton de géolocalisation : on remet l'icône initiale et on retire la classe CSS qui fait tourner le spinner.
  stopLoading() {
    this.geoButtonTarget.classList.replace("fa-spinner", "fa-location-crosshairs")
    this.geoButtonTarget.classList.remove("field-icon-spin")
    this.geoButtonTarget.disabled = false
  }

  // Affiche un message d'erreur sous le champ de recherche pour informer l'utilisateur d'un problème de géolocalisation.
  showError(message) {
    this.errorTarget.textContent = message
    this.errorTarget.classList.remove("d-none")
  }

  // Masque le message d'erreur sous le champ de recherche.
  hideError() {
    this.errorTarget.classList.add("d-none")
  }
}