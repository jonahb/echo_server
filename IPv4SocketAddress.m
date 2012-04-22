#import "IPv4SocketAddress.h"
#import "IPv4Address.h"

@implementation IPv4SocketAddress

- (id)initWithAddress:(IPv4Address *)address port:(NSUInteger)port
{
    return [super initWithAddress:address port:port];
}

- (id)initWithSockaddr:(const struct sockaddr_in *)sockaddr
{
    IPv4Address *address = [[[IPv4Address alloc]
        initWithInAddr:sockaddr->sin_addr]
        autorelease
    ];

    return [self
        initWithAddress:address
        port:ntohs(sockaddr->sin_port)
    ];
}

- (struct sockaddr *)convertToSockaddr
{
    struct sockaddr_in *sockaddr = malloc(sizeof(struct sockaddr_in));

    memset(sockaddr, 0, sizeof(struct sockaddr_in));

    sockaddr->sin_len = sizeof(struct sockaddr_in);
    sockaddr->sin_family = AF_INET;
    sockaddr->sin_port = htons(_port);
    sockaddr->sin_addr = [(IPv4Address *)_address convertToInAddr];

    return (struct sockaddr *)sockaddr;
}

@end

