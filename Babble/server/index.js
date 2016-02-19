var app = require('http').createServer();

app.listen(8000);

var io = require('socket.io')(app);

var username;

io.on('connection', function(socket) {
	//socket.join('MainRoom')
	console.log("a client connected!");

	socket.on('disconnect', function() {
		console.log("a client disconnected!");
	});

	socket.on('username', function(name) {
		username = name;
		io.emit('username', name);
	});

	socket.on('messageSent', function(msg) {
		//io.emit('messageReceived', msg);
		//io.sockets.emit('messageReceived', msg);
		socket.broadcast.emit('messageReceived', msg);
		console.log(username + ": " + msg);
	});
});