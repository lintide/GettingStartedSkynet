const net = require('net');

const client = net.connect({'host': 'localhost', 'port': 8888}, function(){
  console.log('connected to server!');

  var message = "ping";

  var pack = new Buffer(2+message.length);
  pack.writeUInt16BE(message.length, 0);
  pack.write(message, 2);

  // pack 的数据如下
  // | 00 04 | 70 69 6e 67 |
  // | size  |   message   |

  client.write(pack);

})

client.on("data", function(data){
  console.log(data.toString()+" ");
})
