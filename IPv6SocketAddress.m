#import "IPv6SocketAddress.h"
#import "IPv6Address.h"

@implementation IPv6SocketAddress

- (id)initWithAddress:(IPv6Address *)address port:(NSUInteger)port
{
    return [self
        initWithAddress:address
        port:port
        scopeId:0
        flowInfo:0
    ];
}

- (id)initWithSockaddr:(const struct sockaddr_in6 *)sockaddr
{
    IPv6Address *address = [[[IPv6Address alloc]
        initWithIn6Addr:sockaddr->sin6_addr]
        autorelease
    ];

    return [self
        initWithAddress:address
        port:ntohs(sockaddr->sin6_port)
        scopeId:sockaddr->sin6_scope_id
        flowInfo:sockaddr->sin6_flowinfo
    ];
}

- (id)initWithAddress:(IPv6Address *)address
    port:(NSUInteger)port
    scopeId:(NSUInteger)scopeId
    flowInfo:(NSUInteger)flowInfo
{
    self = [super initWithAddress:address port:port];

    if (self) {
        _scopeId = scopeId;
        _flowInfo = flowInfo;
    }

    return self;
}

- (struct sockaddr *)convertToSockaddr
{
    struct sockaddr_in6 *sockaddr = malloc(sizeof(struct sockaddr_in6));

    sockaddr->sin6_len = sizeof(struct sockaddr_in6);
    sockaddr->sin6_family = AF_INET6;
    sockaddr->sin6_port = htons(_port);
    sockaddr->sin6_addr = [(IPv6Address *)_address convertToIn6Addr];
    sockaddr->sin6_flowinfo = (__uint32_t)_flowInfo;
    sockaddr->sin6_scope_id = (__uint32_t)_scopeId;

    return (struct sockaddr *)sockaddr;
}

@end
