document.addEventListener("turbo:load", function() {
  // Mobile hamburger menu toggle
  let hamburger = document.querySelector("#hamburger");
  if (hamburger) {
    hamburger.addEventListener("click", function(event) {
      let menu = document.querySelector("#navbarNav");
      if (menu.classList.contains("show")) {
        menu.classList.remove("show");
      } else {
        menu.classList.add("show");
      }
    });
  }

  // Account dropdown toggle
  let account = document.querySelector("#navbarDropdown");
  if (account) {
    account.addEventListener("click", function(event) {
      event.preventDefault();
      let menu = account.nextElementSibling;
      if (menu && menu.classList.contains("dropdown-menu")) {
        menu.classList.toggle("show");
      }
    });
  }

  // Close dropdown when clicking outside
  document.addEventListener("click", function(event) {
    let dropdowns = document.querySelectorAll(".dropdown-menu.show");
    dropdowns.forEach(function(dropdown) {
      let toggle = dropdown.previousElementSibling;
      if (!toggle.contains(event.target) && !dropdown.contains(event.target)) {
        dropdown.classList.remove("show");
      }
    });
  });
});