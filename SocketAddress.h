#import <Foundation/Foundation.h>
#import <netinet/in.h>

@class Address;

@interface SocketAddress : NSObject
{
    Address *_address;
    NSUInteger _port;
}

@property (assign) NSUInteger port;
@property (retain) Address *address;

- (id)initWithAddress:(Address *)address port:(NSUInteger)port;

+ (SocketAddress *)socketAddressFromData:(NSData *)data;

+ (SocketAddress *)socketAddressFromSockaddr:(const struct sockaddr *)sockaddr;

+ (NSArray *)loopbackSocketAddressesWithService:(NSString *)service;

+ (NSArray *)wildcardSocketAddressesWithService:(NSString *)service;

- (struct sockaddr *)convertToSockaddr;

- (NSData *)convertToData;

@end
