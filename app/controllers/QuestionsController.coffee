module.exports = (app,config,server)->
    controller = {}
    #Todo: replace with persistent data store
    questions = []

    io = require('socket.io').listen server
    io.set 'log level', 1
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
