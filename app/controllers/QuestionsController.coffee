module.exports = (app,config,server)->
    controller = {}
    questions = [] 

    io = require('socket.io').listen(server) 
    io.sockets.on 'connection', (socket)->
        socket.emit 'getQuestions', questions
        socket.on 'addQuestion', (question)->
            questions.push(question)
            socket.broadcast.emit 'getQuestions', questions

    deleteQuestion = ->
        questions.splice 0, 1
        io.sockets.emit 'deleteQuestion', questions
    #Delay is 5 minutes
    setInterval(deleteQuestion, 300000)




    controller.index = [
        (req, res)->
            res.render "Questions",{title:"Immediate Questions"}

    ]
    controller

