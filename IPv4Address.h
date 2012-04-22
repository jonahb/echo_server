#import <netinet/in.h>
#import "Address.h"

@interface IPv4Address : Address
{
    struct in_addr _addr;
}

- (id)initWithInAddr:(struct in_addr)addr;
- (id)initWithString:(NSString *)string;

- (struct in_addr)convertToInAddr;

@end
