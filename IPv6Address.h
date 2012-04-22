#import <netinet/in.h>
#import "Address.h"

@interface IPv6Address : Address
{
    struct in6_addr _addr;
}

- (id)initWithIn6Addr:(struct in6_addr)addr;
- (id)initWithString:(NSString *)string;

- (struct in6_addr)convertToIn6Addr;

@end
