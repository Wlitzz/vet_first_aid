import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bar", "count"]
  static values = { total: Number }

  connect() {
    this.answered = new Set()
    this.update()
  }

  answer(event) {
    const match = event.target.name.match(/\[(\d+)\]/)
    if (match) this.answered.add(match[1])
    this.update()
  }

  update() {
    const n = this.answered.size
    const t = this.totalValue
    const pct = t > 0 ? (n / t) * 100 : 0
    this.barTarget.style.width = `${pct}%`
    this.countTarget.textContent = `${n} of ${t} answered`
  }
}
