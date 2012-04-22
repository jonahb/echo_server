#import "SocketAddress.h"
#import "IPv4Address.h"

@interface IPv4SocketAddress : SocketAddress

- (id)initWithAddress:(IPv4Address *)address port:(NSUInteger)port;

- (id)initWithSockaddr:(const struct sockaddr_in *)sockaddr;

@end
