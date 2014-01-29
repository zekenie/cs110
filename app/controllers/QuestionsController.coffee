console.log 'test'
module.exports = (app,config,server)->
    controller = {}
    questions = [] 

    io = require('socket.io').listen(server) 
    io.sockets.on 'connection', (socket)->
        socket.emit 'getQuestions', questions
        socket.on 'addQuestion', (question)->
            questions.push(question)
            socket.emit 'getQuestions', questions
            socket.broadcast.emit 'getQuestions', questions
            console.log 'server has these questions: ' + questions

    controller.index = [
        (req, res)->
            res.render "Questions",{title:"hello"}
    ]
    controller.recieve = [
        (req, res)->
            
    ]

    controller.get = []
    controller

