#import <Foundation/Foundation.h>

@class SocketAddress;

@interface Address : NSObject

+ (id)addressFromString:(NSString *)string;

- (SocketAddress *)socketAddressWithPort:(NSUInteger)port;

@end
