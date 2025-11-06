import consumer from "./consumer";

document.addEventListener("turbo:load", () => {
  const messagesContainer = document.getElementById("messages");
  if (!messagesContainer) return;

  const eventId = messagesContainer.dataset.eventId;

  consumer.subscriptions.create(
    { channel: "MessagesChannel", event_id: eventId },
    {
      received(data) {
        // Create elements safely instead of using innerHTML with untrusted data
        const p = document.createElement("p");

        const strong = document.createElement("strong");
        strong.textContent = `${data.user}: `; // safe

        const text = document.createTextNode(data.content); // safe

        const time = document.createElement("span");
        time.className = "text-muted";
        time.style.fontSize = "0.9em";
        time.textContent = ` (${data.created_at})`;

        p.appendChild(strong);
        p.appendChild(text);
        p.appendChild(time);

        messagesContainer.appendChild(p);

        // Auto-scroll to bottom
        p.scrollIntoView({ behavior: "smooth", block: "end" });
      },
    }
  );

  // Clear input after submit (if your form posts normally)
  const messageForm = document.getElementById("new_message_form");
  if (messageForm) {
    messageForm.addEventListener("submit", () => {
      // give server a tiny moment then clear
      setTimeout(() => {
        const input = document.getElementById("message_content");
        if (input) {
          input.value = "";
          input.focus();
        }
      }, 50);
    });
  }
});
