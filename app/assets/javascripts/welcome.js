$(document).ready(function(){
    $('a.flip').click(function(e){
        e.preventDefault();
        $('form').animate({height: "toggle", opacity: "toggle"}, "slow");
    });
});