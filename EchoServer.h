#import <Foundation/Foundation.h>
#import "DatagramSocket.h"

@interface EchoServer : NSObject<DatagramSocketDelegate>
{
    DatagramSocket *_socket;
    SocketAddress *_socketAddress;
}

- (id)initWithSocketAddress:(SocketAddress *)socketAddress;

- (BOOL)start:(NSError **)error;

@end
