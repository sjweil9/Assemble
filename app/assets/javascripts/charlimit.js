var ready = function() {
    $('textarea.desc').keyup(function() {
        if (this.value.length > 500) {
            $('#rem_chars').css("color", "red");
        }
        else {
            $('#rem_chars').css("color", "green");
        }
        $('#rem_chars').text(`${this.value.length}/500 characters`);
    });
};

$(document).ready(ready);
$(document).on('page:change', ready);