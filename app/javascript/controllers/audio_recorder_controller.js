import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["recordButton", "stopButton", "durationInput", "fileInput", "duration"]

  connect() {
    this.mediaRecorder = null
    this.audioChunks = []
    this.startTime = null
    this.timerInterval = null
    this.maxDuration = 60000 // 60 seconds in milliseconds
  }

  disconnect() {
    this.stopRecording()
  }

  async startRecording() {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true })

      this.mediaRecorder = new MediaRecorder(stream)
      this.audioChunks = []

      this.mediaRecorder.addEventListener("dataavailable", (event) => {
        this.audioChunks.push(event.data)
      })

      this.mediaRecorder.addEventListener("stop", () => {
        this.handleRecordingComplete()
      })

      this.mediaRecorder.start()
      this.startTime = Date.now()
      this.updateUI("recording")
      this.startTimer()

      // Auto-stop after max duration
      setTimeout(() => {
        if (this.mediaRecorder && this.mediaRecorder.state === "recording") {
          this.stopRecording()
        }
      }, this.maxDuration)

    } catch (error) {
      console.error("Error accessing microphone:", error)
    }
  }

  stopRecording() {
    if (this.mediaRecorder && this.mediaRecorder.state === "recording") {
      this.mediaRecorder.stop()
      this.mediaRecorder.stream.getTracks().forEach(track => track.stop())
      this.stopTimer()
    }
  }

  startTimer() {
    this.timerInterval = setInterval(() => {
      const elapsed = Date.now() - this.startTime
      const seconds = Math.floor(elapsed / 1000)
      const remainingSeconds = 60 - seconds
      this.durationTarget.textContent = `${remainingSeconds}`
    }, 100)
  }

  stopTimer() {
    if (this.timerInterval) {
      clearInterval(this.timerInterval)
      this.timerInterval = null
    }
  }

  async handleRecordingComplete() {
    const duration = Date.now() - this.startTime
    const audioBlob = new Blob(this.audioChunks, { type: this.mediaRecorder.mimeType })

    this.updateUI("uploading")

    try {
      await this.uploadRecording(audioBlob, duration)
      this.updateUI("success")

      // Reload the page to show the new recording
      setTimeout(() => {
        window.location.reload()
      }, 1000)
    } catch (error) {
      console.error("Error uploading recording:", error)
      this.updateUI("error")
    }
  }

  async uploadRecording(audioBlob, duration) {
    this.durationInputTarget.value = duration;

    const audioFile = new File([audioBlob], "recording.webm");
    const dataTransfer = new DataTransfer();

    dataTransfer.items.add(audioFile);
    this.fileInputTarget.files = dataTransfer.files;

    this.element.requestSubmit()
  }

  updateUI(state) {
    switch(state) {
      case "recording":
        this.recordButtonTarget.disabled = true
        this.stopButtonTarget.disabled = false
        break
      case "uploading":
        this.recordButtonTarget.disabled = true
        this.stopButtonTarget.disabled = true
        this.durationTarget.textContent = ""
        break
      case "success":
        break
      case "error":
        this.recordButtonTarget.disabled = false
        this.stopButtonTarget.disabled = true
        this.durationTarget.textContent = ""
        break
      default:
        this.recordButtonTarget.disabled = false
        this.stopButtonTarget.disabled = true
        this.durationTarget.textContent = ""
    }
  }
}
