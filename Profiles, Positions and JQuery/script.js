var countPos = 0;
var countEdu = 0;
// http://stackoverflow.com/questions/17650776/add-remove-html-inside-div-using-javascript
$(document).ready(function(){
    var posFields = document.getElementById("position_fields");
    window.console && console.log('Document ready called');
    $('#addPos').click(function(event){
        // http://api.jquery.com/event.preventdefault/
        event.preventDefault();
        if ( countPos >= 9 ) {
            alert("Maximum of nine position entries exceeded");
            return;
        }
        countPos++;
        for(var i=0; i<posFields.childElementCount; i++){
            if((posFields.children[0].id) === ("position"+countPos)){
                countPos = posFields.childElementCount + 1;
                console.log("position"+countPos+" = "+posFields.children[0].id);
                console.log("new value of countPos = " + countPos);
            }
        }
        window.console && console.log("Adding position "+countPos);
        $('#position_fields').append(
            '<div id="position'+countPos+'">' +
            '<p>Year:'+
            '<input type="text" name="year'+countPos+'" value="" />' +
            '<input type="button" value="-" onclick="$(\'#position'+countPos+'\').remove();return false;">' +
            '</p>' +
            '<textarea name="desc'+countPos+'" rows="8" cols="80"></textarea>' +
            '</div>'
        );
    });
    $('#addEdu').click(function(event){
        event.preventDefault();
        if ( countEdu >= 9 ) {
            alert("Maximum of nine education entries exceeded");
            return;
        }
        countEdu++;
        window.console && console.log("Adding education "+countEdu);
        //Grab some HTML with hot spots and insert into DOM
        var source = $("#edu-template").html();
        $('#edu_fields').append(source.replace(/@COUNT@/g, countEdu));
        // Add the event handler to the new ones
        $('.school').autocomplete({
            source: "school.php"
        });
    });
    $('.school').autocomplete({
        source: "school.php"
    });
});
