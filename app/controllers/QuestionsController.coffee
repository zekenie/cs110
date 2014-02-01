console.log 'test'
module.exports = (app,config,server)->
    controller = {}
    questions = [] 

    io = require('socket.io').listen(server) 
    io.sockets.on 'connection', (socket)->
        socket.emit 'getQuestions', questions
        socket.on 'addQuestion', (question)->
            questions.push(question)
            console.log 'server has these questions: ' + questions
            socket.broadcast.emit 'getQuestions', questions

    deleteQuestion = ()->
        questions.splice 0, 1
        console.log 'questions now: ' + questions
        io.sockets.emit 'deleteQuestion', questions
        console.log 'delete'

    setInterval(()->
            deleteQuestion()
        , 10000)




    controller.index = [
        (req, res)->
            res.render "Questions",{title:"hello"}

    ]
    controller

