import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleButton", "recordIcon", "stopIcon", "durationInput", "fileInput", "duration"]

  connect() {
    this.mediaRecorder = null
    this.audioChunks = []
    this.startTime = null
    this.timerInterval = null
    this.maxDuration = 600000 // 10 minutes in milliseconds
    this.isRecording = false
  }

  disconnect() {
    this.stopRecording()
  }

  toggleRecording() {
    if (this.isRecording) {
      this.stopRecording()
    } else {
      this.startRecording()
    }
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
      this.isRecording = true
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
      this.isRecording = false
      this.stopTimer()
    }
  }

  startTimer() {
    this.timerInterval = setInterval(() => {
      const elapsed = Date.now() - this.startTime
      const totalSeconds = Math.floor(elapsed / 1000)
      const minutes = Math.floor(totalSeconds / 60)
      const seconds = totalSeconds % 60

      // Format as MM:SS with zero-padding
      const formattedTime = `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`
      this.durationTarget.textContent = formattedTime

      // Turn red at 9 minutes (540 seconds)
      if (totalSeconds >= 540) {
        this.durationTarget.classList.add('text-red-600')
      } else {
        this.durationTarget.classList.remove('text-red-600')
      }
    }, 100)
  }

  stopTimer() {
    if (this.timerInterval) {
      clearInterval(this.timerInterval)
      this.timerInterval = null
    }
    // Reset timer display and color
    this.durationTarget.textContent = ""
    this.durationTarget.classList.remove('text-red-600')
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
        this.recordIconTarget.classList.add("hidden")
        this.stopIconTarget.classList.remove("hidden")
        this.toggleButtonTarget.disabled = false
        break
      case "uploading":
        this.toggleButtonTarget.disabled = true
        this.durationTarget.textContent = ""
        this.durationTarget.classList.remove('text-red-600')
        break
      case "success":
        break
      case "error":
        this.recordIconTarget.classList.remove("hidden")
        this.stopIconTarget.classList.add("hidden")
        this.toggleButtonTarget.disabled = false
        this.durationTarget.textContent = ""
        this.durationTarget.classList.remove('text-red-600')
        break
      default:
        this.recordIconTarget.classList.remove("hidden")
        this.stopIconTarget.classList.add("hidden")
        this.toggleButtonTarget.disabled = false
        this.durationTarget.textContent = ""
        this.durationTarget.classList.remove('text-red-600')
    }
  }
}
