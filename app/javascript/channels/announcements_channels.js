import consumer from "./consumer"

document.addEventListener("turbo:load", () => {
  const announcementsContainer = document.getElementById("announcements")
  if (!announcementsContainer) return

  const eventId = announcementsContainer.dataset.eventId
  if (!eventId) return

  consumer.subscriptions.create(
    { channel: "AnnouncementsChannel", event_id: eventId },
    {
      received(data) {
        const html = `<p><strong>${data.user}:</strong> ${data.message} <span class="text-muted" style="font-size:0.9em">(${data.created_at})</span></p>`
        announcementsContainer.insertAdjacentHTML("afterbegin", html)
      }
    }
  )
})
