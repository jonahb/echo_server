A UDP echo server. I wrote this to learn about CFNetwork, UDP, and socket programming in general. I also couldn't believe things had to be as complicated as Apple's UDPEcho sample.

Run it without arguments to bind to a wildcard address and port 3000:

`EchoServer`

Or give it an address (IPv4 or IPv6) and port:

`EchoServer 127.0.0.1 3000`

Then try it out with netcat:

`echo you look marvelous | nc -u 127.0.0.1 3000`
