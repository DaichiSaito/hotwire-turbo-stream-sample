import { Controller } from "@hotwired/stimulus"

const DEFAULT_DELAY = 3000;

export default class extends Controller {

  connect() {
    const delay = (this.data.get("delay") | 0) || DEFAULT_DELAY;
    setTimeout(() => { this.destroy() }, delay);
  }

  destroy() {
    this.element.remove();
  }
}
