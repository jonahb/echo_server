#import <arpa/inet.h>
#import "IPv4Address.h"
#import "IPv4SocketAddress.h"

@implementation IPv4Address

- (id)initWithInAddr:(struct in_addr)addr
{
    self = [super init];

    if (self) {
        _addr = addr;
    }

    return self;
}

- (id)initWithString:(NSString *)string
{
    struct in_addr addr;

    int result = inet_pton(
        AF_INET,
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

    return [self initWithInAddr:addr];
}

- (struct in_addr)convertToInAddr
{
    return _addr;
}

- (NSString *)description
{
    char addrstr[INET_ADDRSTRLEN];

    if (NULL == inet_ntop(AF_INET, &_addr, &addrstr[0], INET_ADDRSTRLEN))
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

- (IPv4SocketAddress *)socketAddressWithPort:(NSUInteger)port
{
    return [[[IPv4SocketAddress alloc]
        initWithAddress:self
        port:port]
        autorelease];
}

@end
