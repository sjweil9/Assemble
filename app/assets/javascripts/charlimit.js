$(document).ready(function() {
    $('textarea.desc').keydown(function() {
        if (this.value.length > 500) {
            $('#rem_chars').css("color", "red");
        }
        else {
            $('#rem_chars').css("color", "green");
        }
        $('#rem_chars').text(`${this.value.length}/500 characters`);
    });
});