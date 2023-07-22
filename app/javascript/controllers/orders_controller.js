import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
    addOrder(e) {
        e.preventDefault()
        const params = new URLSearchParams
        const url = e.target.href
        const options = {
            method: 'GET',
            headers: { Accept: 'text/vnd.turbo-stream.html' },
            dataType: 'turbo_stream',

        }
        fetch(`${url}?${params}`, options)
            .then(response => response.text())
            .then(html => Turbo.renderStreamMessage(html))
    }
}
