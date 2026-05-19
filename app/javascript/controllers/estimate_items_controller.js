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

  update(e) {
    if (e?.target?.classList.contains("inp-qty")) {
      const card = e.target.closest(".item-card")
      if (card) this.updatePriceFields(card)
    }
    this.syncJson()
    this.recalc()
  }

  selectUnit(e) {
    const card = e.target.closest(".item-card")
    card.querySelector(".inp-unit").value = e.target.dataset.unit
    this.syncJson()
  }

  addMaterial(e) {
    const card = e.target.closest(".item-card")
    const list = card.querySelector(".material-list")
    list.appendChild(this.buildMaterialRow({}))
  }

  removeMaterial(e) {
    e.target.closest(".material-row").remove()
    this.syncJson()
    this.recalc()
  }

  // 数量に合わせて単価欄の数を調整する
  updatePriceFields(card) {
    const qty = parseInt(card.querySelector(".inp-qty").value, 10)
    const list = card.querySelector(".price-list")
    const inputs = list.querySelectorAll(".price-row-input")
    const target = (!isNaN(qty) && qty >= 2) ? qty : 1

    if (target > inputs.length) {
      for (let i = inputs.length; i < target; i++) {
        list.appendChild(this.buildPriceInput(""))
      }
    } else if (target < inputs.length) {
      Array.from(inputs).slice(target).forEach(el => el.remove())
    }
  }

  buildPriceInput(value = "") {
    const input = document.createElement("input")
    input.type = "text"
    input.inputMode = "numeric"
    input.className = "price-row-input block w-full border border-gray-300 rounded-md px-3 py-2 text-sm text-right focus:outline-green-600 bg-white"
    input.value = value
    input.placeholder = "25,000"
    input.setAttribute("data-action", "input->estimate-items#update")
    return input
  }

  syncJson() {
    const cards = this.listTarget.querySelectorAll(".item-card")
    const items = Array.from(cards).map(card => {
      const materials = Array.from(card.querySelectorAll(".material-row")).map(row => ({
        name: row.querySelector(".inp-material-name").value,
        qty:  row.querySelector(".inp-material-qty").value,
        cost: row.querySelector(".inp-material-cost").value.replace(/,/g, "")
      }))
      const priceInputs = Array.from(card.querySelectorAll(".price-row-input"))
      const prices = priceInputs.map(el => el.value.replace(/,/g, ""))
      const unit_price = prices[0] || ""
      const unit_prices = prices.length > 1 ? prices : undefined
      return {
        description: card.querySelector(".inp-desc").value,
        qty:         card.querySelector(".inp-qty").value,
        unit:        card.querySelector(".inp-unit").value,
        unit_price,
        unit_prices,
        note:        card.querySelector(".inp-note").value,
        materials
      }
    })
    this.jsonTarget.value = JSON.stringify(items)
  }

  recalc() {
    this.syncJson()
    let workSubtotal = 0
    let materialSubtotal = 0
    this.listTarget.querySelectorAll(".item-card").forEach(card => {
      const priceInputs = Array.from(card.querySelectorAll(".price-row-input"))
      let amt
      if (priceInputs.length > 1) {
        amt = Math.round(priceInputs.reduce((sum, el) => {
          return sum + (parseFloat(el.value.replace(/,/g, "")) || 0)
        }, 0))
      } else {
        const qty   = parseFloat(card.querySelector(".inp-qty").value) || 0
        const price = parseFloat(priceInputs[0]?.value.replace(/,/g, "")) || 0
        amt = Math.round(qty * price)
      }
      card.querySelector(".cell-amount").textContent = amt > 0 ? "¥" + amt.toLocaleString("ja-JP") : "—"
      workSubtotal += amt
      card.querySelectorAll(".material-row").forEach(row => {
        materialSubtotal += parseFloat(row.querySelector(".inp-material-cost").value.replace(/,/g, "")) || 0
      })
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

  buildMaterialRow(mat = {}) {
    const div = document.createElement("div")
    div.className = "material-row grid grid-cols-5 gap-1 items-center"
    div.innerHTML = `
      <div class="col-span-2">
        <input type="text" class="inp-material-name block w-full border border-amber-200 rounded-md px-2 py-1.5 text-sm focus:outline-amber-400 bg-amber-50"
          value="${mat.name || ""}" placeholder="資材名"
          data-action="input->estimate-items#update">
      </div>
      <div>
        <input type="text" inputmode="decimal" class="inp-material-qty block w-full border border-amber-200 rounded-md px-2 py-1.5 text-sm text-right focus:outline-amber-400 bg-amber-50"
          value="${mat.qty || ""}" placeholder="個数"
          data-action="input->estimate-items#update">
      </div>
      <div>
        <input type="text" inputmode="numeric" class="inp-material-cost block w-full border border-amber-200 rounded-md px-2 py-1.5 text-sm text-right focus:outline-amber-400 bg-amber-50"
          value="${mat.cost || ""}" placeholder="金額"
          data-action="input->estimate-items#update">
      </div>
      <div class="flex justify-center">
        <button type="button" class="text-gray-300 hover:text-red-400 text-lg leading-none"
          data-action="click->estimate-items#removeMaterial">×</button>
      </div>
    `
    return div
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
          <div class="price-list mt-0.5 space-y-1"></div>
        </div>
        <div>
          <label class="text-xs text-gray-500">施工費</label>
          <div class="cell-amount mt-0.5 block w-full border border-gray-100 rounded-md px-3 py-2 text-sm text-right font-medium text-green-800 bg-white">—</div>
        </div>
      </div>
      <div class="space-y-1.5">
        <div class="flex items-center justify-between">
          <label class="text-xs text-amber-600">資材</label>
          <button type="button" class="text-xs text-amber-600 hover:text-amber-800"
            data-action="click->estimate-items#addMaterial">＋ 資材を追加</button>
        </div>
        <div class="material-list space-y-1.5"></div>
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

    // 単価欄：unit_prices配列があればその数だけ、なければ1つ
    const priceList = div.querySelector(".price-list")
    const unit_prices = (item.unit_prices && item.unit_prices.length > 1)
      ? item.unit_prices
      : [item.unit_price || ""]
    unit_prices.forEach(p => priceList.appendChild(this.buildPriceInput(p)))

    // 資材行
    const materials = item.materials || (item.material_name ? [{ name: item.material_name, cost: item.material_cost }] : [])
    const matList = div.querySelector(".material-list")
    materials.forEach(m => matList.appendChild(this.buildMaterialRow(m)))

    return div
  }

  loadItems(items) {
    this.listTarget.innerHTML = ""
    items.forEach(item => this.listTarget.appendChild(this.buildCard(item)))
    this.recalc()
  }
}
