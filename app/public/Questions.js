$(function(){
    var socket = io.connect();
    var self = this;
    var questions = [];
    var goodreverse = function(a) {
        var temp = [];
        var len = a.length;
        for (var i = (len - 1); i !== 0; i--) {
            temp.push(a[i]);
        }
        return temp;
    }
    var generateQuestions = function(){
        $('#questionsdisplay').html('');
        console.log('genreating questions: '+ questions);
        correctDisplay = goodreverse(questions)
        correctDisplay.forEach(function(entry){
            $('#questionsdisplay').append('<pre>' + entry + '</pre>' + '<br>');
        
        });
    }
    var addQuestion =function(question){
        $('#questionsdisplay').prepend('<pre>'+question+'</pre>');
    }
    socket.on('deleteQuestion', function (newQuestions){
        questions = newQuestions;
        generateQuestions();
    });
    socket.on('getQuestions', function (squestions){
        console.log("questions on server: "+squestions);
        if(squestions.length > 0){
            questions = squestions;
            generateQuestions();
        }
    });
    $('#questionform').submit(function(event){
        event.preventDefault();

        var text = $('#questioninput').val()
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
