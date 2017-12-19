$(document).ready(function() {
    $('textarea.comment').keyup(function() {
        if (this.value.length > 140) {
            $('#rem_chars').css("color", "red");
        }
        else {
            $('#rem_chars').css("color", "green");
        }
        $('#rem_chars').text(`${this.value.length}/140 characters`);
    });
});