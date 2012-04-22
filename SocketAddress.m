#import <sys/types.h>
#import <sys/socket.h>
#import <netdb.h>
#import "SocketAddress.h"
#import "IPv4SocketAddress.h"
#import "IPv6SocketAddress.h"
#import "Address.h"


@interface SocketAddress ()

+ (NSArray *)socketAddressesWithService:(NSString *)service
    hostname:(NSString *)hostname
    hints:(struct addrinfo *)hints;

@end



@implementation SocketAddress

@synthesize address = _address;
@synthesize port = _port;

- (id)initWithAddress:(Address *)address port:(NSUInteger)port
{
    self = [super init];

    if (self) {
        _address = [address retain];
        _port = port;
    }

    return self;
}

+ (SocketAddress *)socketAddressFromData:(NSData *)data
{
    return [SocketAddress
        socketAddressFromSockaddr:(const struct sockaddr *)[data bytes]
    ];
}

+ (SocketAddress *)socketAddressFromSockaddr:(const struct sockaddr *)sockaddr
{
    switch (sockaddr->sa_family)
    {
        case AF_INET:
        {
            return [[[IPv4SocketAddress alloc]
                initWithSockaddr:(const struct sockaddr_in *)sockaddr]
                autorelease
            ];
        }
        case AF_INET6:
        {
            return [[[IPv6SocketAddress alloc]
                initWithSockaddr:(const struct sockaddr_in6 *)sockaddr]
                autorelease
            ];
        }
    }

    return nil;
}

- (void)dealloc
{
    [_address release];
    [super dealloc];
}

+ (NSArray *)wildcardSocketAddressesWithService:(NSString *)service
{
    struct addrinfo hints;

    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_flags = AI_PASSIVE;
    hints.ai_socktype = SOCK_DGRAM;

    return [self
        socketAddressesWithService:service
        hostname:NULL
        hints:&hints
    ];
}

+ (NSArray *)loopbackSocketAddressesWithService:(NSString *)service
{
    struct addrinfo hints;

    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_flags = 0;
    hints.ai_socktype = SOCK_DGRAM;

    return [self
        socketAddressesWithService:service
        hostname:NULL
        hints:&hints
    ];
}

- (NSString *)description
{
    return [NSString
        stringWithFormat:@"%@:%d",
        _address,
        _port
    ];
}

- (NSData *)convertToData
{
    struct sockaddr *sockaddr = [self convertToSockaddr];

    NSData *data = [NSData
        dataWithBytes:sockaddr
        length:sockaddr->sa_len
    ];

    free(sockaddr);

    return data;
}

- (struct sockaddr *)convertToSockaddr
{
    [NSException
        raise:@"NotImplemented"
        format:@"Subclasses must implement convertToSockaddr"
    ];

    return nil;
}

+ (NSArray *)socketAddressesWithService:(NSString *)service
    hostname:(NSString *)hostname
    hints:(struct addrinfo *)hints
{
    struct addrinfo *addrinfo;

    int status = getaddrinfo(
        [hostname cStringUsingEncoding:[NSString defaultCStringEncoding]],
        [service cStringUsingEncoding:[NSString defaultCStringEncoding]],
        hints,
        &addrinfo
    );

    if (status) {
        return nil;
    }

    NSMutableArray *addresses = [NSMutableArray array];

    for (; addrinfo != NULL; addrinfo = addrinfo->ai_next)
    {
        [addresses
            addObject: [SocketAddress socketAddressFromSockaddr:addrinfo->ai_addr]
        ];
    }

    freeaddrinfo(addrinfo);

    return addresses;
}

@end
