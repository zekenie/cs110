$(function(){
    var socket = io.connect();
    var questions = [];
    var firstGenerate = true;
    var audio = new Audio("/notification.wav");
    var $questionsdisplay = $('#questionsdisplay');
    var $questionform = $('#questionform');
    var $questioninput = $('#questioninput');
    var generateQuestions = function(){
        $questionsdisplay.html('');
        questions.forEach(function(entry){
            $questionsdisplay.prepend('<pre>' + entry + '</pre>');
        });
    }
    var addQuestion =function(question){
        $questionsdisplay.prepend('<pre>'+question+'</pre>');
    }
    socket.on('deleteQuestion', function (newQuestions){
        questions = newQuestions;
        generateQuestions();
    });
    socket.on('getQuestions', function (squestions){
        if(!firstGenerate){
            audio.play();
        }else{
            firstGenerate = false;
        }
        console.log("questions on server: "+squestions);
        if(squestions.length > 0){
            questions = squestions;
            generateQuestions();
        }
    });
    $questionform.submit(function(event){
        event.preventDefault();
        var text = $questioninput.val();
        if(text !== ""){
            console.log("text: " + text);
            //Horribly formatted regex, to allow people to submit HTML ;
            question = text.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/'/g, '&#039;');
            addQuestion(question);
            socket.emit('addQuestion', question);
            $('#questioninput').val('');
        }
    
    });
});
