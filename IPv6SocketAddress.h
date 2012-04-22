#import "SocketAddress.h"
#import "IPv6Address.h"

@interface IPv6SocketAddress : SocketAddress
{
    NSUInteger _scopeId;
    NSUInteger _flowInfo;
}

- (id)initWithAddress:(IPv6Address *)address port:(NSUInteger)port;

- (id)initWithAddress:(IPv6Address *)address
    port:(NSUInteger)port
    scopeId:(NSUInteger)scopeId
    flowInfo:(NSUInteger)flowInfo;

- (id)initWithSockaddr:(const struct sockaddr_in6 *)sockaddr;

@end
