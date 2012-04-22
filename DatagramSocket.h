#import <Foundation/Foundation.h>
#import "SocketAddress.h"



@protocol DatagramSocketDelegate;



enum {
    DatagramSocketUnknownError = 1,
    DatagramSocketTimeout = 2
};



@interface DatagramSocket : NSObject
{
    CFSocketRef _socket;
    CFRunLoopSourceRef _runLoopSource;
}
@property (assign) id<DatagramSocketDelegate> delegate;

- (BOOL)sendData:(NSData *)data
    toSocketAddress:(SocketAddress *)address
    error:(NSError **)error;

- (BOOL)bindToSocketAddress:(SocketAddress *)address
    error:(NSError **)error;

- (void)startReceiving;

- (void)stopReceiving;

@end




@protocol DatagramSocketDelegate

- (void)datagramSocket:(DatagramSocket *)socket
    didReceiveData:(NSData *)data
    fromSocketAddress:(SocketAddress *)address;

@end