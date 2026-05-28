import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display"]
  static values = { seconds: Number }

  connect() {
    this.remaining = this.secondsValue
    this.render()
    this.interval = setInterval(() => {
      this.remaining--
      this.render()
      if (this.remaining <= 0) this.timeout()
    }, 1000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  render() {
    const m = Math.floor(this.remaining / 60)
    const s = this.remaining % 60
    this.displayTarget.textContent = `${m}:${s.toString().padStart(2, "0")}`
    if (this.remaining <= 30) {
      this.displayTarget.classList.add("text-red-500")
      this.displayTarget.classList.remove("text-gray-700")
    }
  }

  timeout() {
    clearInterval(this.interval)
    const form = this.element.querySelector("form")
    if (form) form.submit()
  }
}
