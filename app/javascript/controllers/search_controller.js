import { Controller } from "@hotwired/stimulus"

// Pilote le champ de recherche des venues.
// Deux modes exclusifs : recherche texte OU géolocalisation.
// Un seul bouton visible à droite du champ : geo si le champ est vide, clear sinon.
export default class extends Controller {
  static targets = ["input", "clearButton", "geoButton", "searchIcon",
                    "latitude", "longitude", "error"]
  static values = { aroundYouLabel: String }

  // Taper du texte annule la géolocalisation : les deux modes sont exclusifs.
  onInput() {
    this.clearCoordinates()
    this.hideError()
    this.toggleButtons()
    this.submit()
  }

  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.element.requestSubmit(), 300)
  }

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

  onLocationError(error) {
    this.stopLoading()
    const messages = {
      1: "Location access denied. Enable it in your browser settings to see venues around you.",
      2: "We couldn't get your location. Try again or search by name.",
      3: "Locating took too long. Try again or search by name."
    }
    this.showError(messages[error.code] || messages[2])
  }

  clearQuery() {
    clearTimeout(this.timeout)
    const wasGeolocated = this.hasCoordinates
    this.resetField()
    this.hideError()
    // Pas de refocus en sortie de géoloc : évite de faire remonter le clavier mobile.
    if (!wasGeolocated) this.inputTarget.focus()
    this.element.requestSubmit()
  }

  // --- private ---

  get hasCoordinates() {
    return this.latitudeTarget.value !== ""
  }

  get isActive() {
    return this.inputTarget.value !== "" || this.hasCoordinates
  }

  toggleButtons() {
    this.clearButtonTarget.classList.toggle("d-none", !this.isActive)
    this.geoButtonTarget.classList.toggle("d-none", this.isActive)
  }

  clearCoordinates() {
    this.latitudeTarget.value = ""
    this.longitudeTarget.value = ""
  }

  showAroundYou() {
    this.inputTarget.value = this.capitalize(this.aroundYouLabelValue)
    this.inputTarget.readOnly = true
    this.inputTarget.classList.add("is-active")
    this.searchIconTarget.classList.replace("fa-magnifying-glass", "fa-location-dot")
    this.toggleButtons()
  }

  resetField() {
    this.inputTarget.value = ""
    this.inputTarget.readOnly = false
    this.inputTarget.classList.remove("is-active")
    this.searchIconTarget.classList.replace("fa-location-dot", "fa-magnifying-glass")
    this.clearCoordinates()
    this.toggleButtons()
  }

  capitalize(text) {
    return text.charAt(0).toUpperCase() + text.slice(1)
  }

  startLoading() {
    this.geoButtonTarget.classList.replace("fa-location-crosshairs", "fa-spinner")
    this.geoButtonTarget.classList.add("field-icon-spin")
    this.geoButtonTarget.disabled = true
  }

  stopLoading() {
    this.geoButtonTarget.classList.replace("fa-spinner", "fa-location-crosshairs")
    this.geoButtonTarget.classList.remove("field-icon-spin")
    this.geoButtonTarget.disabled = false
  }

  showError(message) {
    this.errorTarget.textContent = message
    this.errorTarget.classList.remove("d-none")
  }

  hideError() {
    this.errorTarget.classList.add("d-none")
  }
}