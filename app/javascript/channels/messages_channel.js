import consumer from "./consumer"

document.addEventListener("turbo:load", () => {
  const messagesContainer = document.getElementById("messages")
  if (!messagesContainer) return

  const eventId = messagesContainer.dataset.eventId
  if (!eventId) return

  consumer.subscriptions.create(
    { channel: "MessagesChannel", event_id: eventId },
    {
      received(data) {
        const html = `<p><strong>${data.user}:</strong> ${data.content} <span class="text-muted" style="font-size:0.9em">(${data.created_at})</span></p>`
        messagesContainer.insertAdjacentHTML("beforeend", html)
        messagesContainer.scrollTop = messagesContainer.scrollHeight
      }
    }
  )
})
