import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["file"]

  connect() {
    this.fileTarget.addEventListener("change", event => {
      this.element.requestSubmit()
    })
  }

  openFileSelector() {
    this.fileTarget.click()
  }
}
