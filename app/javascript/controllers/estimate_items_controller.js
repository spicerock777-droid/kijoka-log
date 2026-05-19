import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "json", "workSubtotal", "materialSubtotal", "tax", "total"]

  connect() {
    this.recalc()
    this.element.addEventListener("keydown", this.handleEnter.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("keydown", this.handleEnter.bind(this))
  }

  handleEnter(e) {
    if (e.key !== "Enter") return
    const inputs = Array.from(this.element.querySelectorAll("input:not([type='hidden']), textarea, button[type='button']"))
    const idx = inputs.indexOf(e.target)
    if (idx !== -1 && idx < inputs.length - 1) {
      e.preventDefault()
      inputs[idx + 1].focus()
    } else if (idx === inputs.length - 1) {
      e.preventDefault()
    }
  }

  addRow() {
    const card = this.buildCard({})
    this.listTarget.appendChild(card)
  }

  removeRow(e) {
    e.target.closest(".item-card").remove()
    this.syncJson()
    this.recalc()
  }

  update() {
    this.syncJson()
    this.recalc()
  }

  selectUnit(e) {
    const card = e.target.closest(".item-card")
    card.querySelector(".inp-unit").value = e.target.dataset.unit
    this.syncJson()
  }

  syncJson() {
    const cards = this.listTarget.querySelectorAll(".item-card")
    const items = Array.from(cards).map(card => ({
      description:   card.querySelector(".inp-desc").value,
      qty:           card.querySelector(".inp-qty").value,
      unit:          card.querySelector(".inp-unit").value,
      unit_price:    card.querySelector(".inp-price").value.replace(/,/g, ""),
      note:          card.querySelector(".inp-note").value,
      material_name: card.querySelector(".inp-material-name").value,
      material_cost: card.querySelector(".inp-material-cost").value.replace(/,/g, "")
    }))
    this.jsonTarget.value = JSON.stringify(items)
  }

  recalc() {
    this.syncJson()
    let workSubtotal = 0
    let materialSubtotal = 0
    this.listTarget.querySelectorAll(".item-card").forEach(card => {
      const qty  = parseFloat(card.querySelector(".inp-qty").value) || 0
      const price = parseFloat(card.querySelector(".inp-price").value.replace(/,/g, "")) || 0
      const mat  = parseFloat(card.querySelector(".inp-material-cost").value.replace(/,/g, "")) || 0
      const amt  = Math.round(qty * price)
      const amtEl = card.querySelector(".cell-amount")
      amtEl.textContent = amt > 0 ? "¥" + amt.toLocaleString("ja-JP") : "—"
      workSubtotal += amt
      materialSubtotal += mat
    })
    const subtotal = workSubtotal + materialSubtotal
    const tax   = Math.floor(subtotal * 0.1)
    const total = subtotal + tax
    const fmt   = n => "¥" + n.toLocaleString("ja-JP")
    this.workSubtotalTarget.textContent     = fmt(workSubtotal)
    this.materialSubtotalTarget.textContent = fmt(materialSubtotal)
    this.taxTarget.textContent              = fmt(tax)
    this.totalTarget.textContent            = fmt(total)
  }

  buildCard(item = {}) {
    const div = document.createElement("div")
    div.className = "item-card bg-gray-50 border border-gray-200 rounded-lg p-3 space-y-2"
    div.innerHTML = `
      <div>
        <label class="text-xs text-gray-500">施工内容</label>
        <input type="text" class="inp-desc mt-0.5 block w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:outline-green-600 bg-white"
          value="${item.description || ""}" placeholder="例：水脈整備（浅溝・点穴）"
          data-action="input->estimate-items#update">
      </div>
      <div class="grid grid-cols-2 gap-2">
        <div>
          <label class="text-xs text-gray-500">数量</label>
          <input type="text" inputmode="decimal" class="inp-qty mt-0.5 block w-full border border-gray-300 rounded-md px-3 py-2 text-sm text-right focus:outline-green-600 bg-white"
            value="${item.qty || ""}" placeholder="1"
            data-action="input->estimate-items#update">
        </div>
        <div>
          <label class="text-xs text-gray-500">単位</label>
          <input type="text" class="inp-unit mt-0.5 block w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:outline-green-600 bg-white"
            value="${item.unit || "式"}">
          <div class="flex gap-1 mt-1 flex-wrap">
            ${["式","人","日","回","m²","m"].map(u => `<button type="button" class="unit-chip text-xs px-2 py-0.5 border border-gray-300 rounded bg-white hover:bg-green-50 active:bg-green-100" data-action="click->estimate-items#selectUnit" data-unit="${u}">${u}</button>`).join("")}
          </div>
        </div>
      </div>
      <div class="grid grid-cols-2 gap-2">
        <div>
          <label class="text-xs text-gray-500">単価（円）</label>
          <input type="text" inputmode="numeric" class="inp-price mt-0.5 block w-full border border-gray-300 rounded-md px-3 py-2 text-sm text-right focus:outline-green-600 bg-white"
            value="${item.unit_price || ""}" placeholder="25,000"
            data-action="input->estimate-items#update">
        </div>
        <div>
          <label class="text-xs text-gray-500">施工費</label>
          <div class="cell-amount mt-0.5 block w-full border border-gray-100 rounded-md px-3 py-2 text-sm text-right font-medium text-green-800 bg-white">—</div>
        </div>
      </div>
      <div class="grid grid-cols-2 gap-2">
        <div>
          <label class="text-xs text-gray-500">資材名</label>
          <input type="text" class="inp-material-name mt-0.5 block w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:outline-green-600 bg-white"
            value="${item.material_name || ""}" placeholder="竹、砂利など"
            data-action="input->estimate-items#update">
        </div>
        <div>
          <label class="text-xs text-gray-500">資材費（円）</label>
          <input type="text" inputmode="numeric" class="inp-material-cost mt-0.5 block w-full border border-gray-300 rounded-md px-3 py-2 text-sm text-right focus:outline-green-600 bg-white"
            value="${item.material_cost || ""}" placeholder="0"
            data-action="input->estimate-items#update">
        </div>
      </div>
      <div>
        <label class="text-xs text-gray-500">備考</label>
        <input type="text" class="inp-note mt-0.5 block w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:outline-green-600 bg-white"
          value="${item.note || ""}" placeholder="（任意）"
          data-action="input->estimate-items#update">
      </div>
      <div class="flex justify-end">
        <button type="button" class="text-xs text-red-400 hover:text-red-600"
          data-action="click->estimate-items#removeRow">この行を削除</button>
      </div>
    `
    return div
  }

  loadItems(items) {
    this.listTarget.innerHTML = ""
    items.forEach(item => this.listTarget.appendChild(this.buildCard(item)))
    this.recalc()
  }
}
