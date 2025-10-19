import { Controller } from "@hotwired/stimulus"
import WaveSurfer from "wavesurfer.js"

export default class extends Controller {
  static targets = ["container", "audio", "playPause"]
  static values = {
    url: String
  }

  connect() {
    this.wavesurfer = WaveSurfer.create({
      container: this.containerTarget,
      vertical: true,
      waveColor: "#AAAAAA",
      progressColor: "#00FF88",
      cursorColor: "#FFFFFF",
      cursorWidth: 2,
      barWidth: 4,
      barRadius: 2,
      height: 80,
      normalize: true,
      interact: true
    })

    this.wavesurfer.load(this.urlValue)

    this.wavesurfer.on("seek", () => {
      this.wavesurfer.play()
    })
  }

  playPause() {
    this.wavesurfer.playPause()
  }

  disconnect() {
    if (this.wavesurfer) {
      this.wavesurfer.destroy()
    }
  }
}
