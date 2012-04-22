#import "Address.h"
#import "SocketAddress.h"
#import "IPv4Address.h"
#import "IPv6Address.h"

@implementation Address

+ (id)addressFromString:(NSString *)string
{
    Address *address;

    if ((address = [[[IPv4Address alloc] initWithString:string] autorelease])) {
        return address;
    }

    if ((address = [[[IPv6Address alloc] initWithString:string] autorelease])) {
        return address;
    }

    return nil;
}

- (SocketAddress *)socketAddressWithPort:(NSUInteger)port
{
    [NSException
        raise:@"NotImplemented"
        format:@"Subclasses must implemented socketAddressWithPort:"
    ];

    return nil;
}

@end
