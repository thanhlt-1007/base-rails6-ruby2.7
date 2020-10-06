$(document).ready(function() {
  setTimeout(function() {
    $("#flash-message .alert, .error-message .alert").fadeOut(3000);
  }, 5000);
});

$(document).on("click", "#flash-message .close-message", function() {
  $(this).closest("#flash-message .alert").fadeOut();
});
