#import <arpa/inet.h>
#import "IPv6Address.h"
#import "IPv6SocketAddress.h"

@implementation IPv6Address

- (id)initWithIn6Addr:(struct in6_addr)addr
{
    self = [super init];

    if (self) {
        _addr = addr;
    }

    return self;
}

- (id)initWithString:(NSString *)string
{
    struct in6_addr addr;

    int result = inet_pton(
        AF_INET6,
        [string cStringUsingEncoding:[NSString defaultCStringEncoding]],
        &addr
    );

    // system error
    if (result == -1) {
        [self release];
        return nil;
    }

    // unparseable; errno is set
    if (result == 0) {
        [self release];
        return nil;
    }

    return [self initWithIn6Addr:addr];
}

- (struct in6_addr)convertToIn6Addr
{
    return _addr;
}

- (NSString *)description
{
    char addrstr[INET6_ADDRSTRLEN];

    if (NULL == inet_ntop(AF_INET6, &_addr, &addrstr[0], INET6_ADDRSTRLEN))
    {
        [NSException
            raise:@"InvalidAddress"
            format:@"The supplied address could not be formatted"
        ];
    }

    return [NSString
        stringWithCString:addrstr
        encoding:[NSString defaultCStringEncoding]
    ];
}

- (IPv6SocketAddress *)socketAddressWithPort:(NSUInteger)port
{
    return [[[IPv6SocketAddress alloc]
        initWithAddress:self
        port:port]
        autorelease];
}

@end