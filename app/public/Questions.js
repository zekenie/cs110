$(function(){
    var socket = io.connect();
    var questions = [];
    var generateQuestions = function(){
        $('#questionsdisplay').html('');
        questions.reverse().forEach(function(entry){
            $('#questionsdisplay').append('<pre>' + entry + '</pre>' + '<br>');
        
        });
    }
    socket.on('getQuestions', function (squestions){
        console.log("questions on server: "+squestions);
        questions = squestions;
        generateQuestions();
    });
    $('#questionform').submit(function(event){
        event.preventDefault();
        text = $('#questioninput').val()
        if(text !== ""){
            console.log("text: " + text);
            //Horribly formatted regex, to allow people to submit HTML 
            socket.emit('addQuestion', text.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/'/g, '&#039;'));
            $('#questioninput').val('');
        }
    
    });
});
