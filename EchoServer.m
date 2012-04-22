#import "EchoServer.h"
#import "Address.h"

@implementation EchoServer

- (id)init
{
    NSArray *wildcards = [SocketAddress wildcardSocketAddressesWithService:@"3000"];

    if ((nil == wildcards) || ([wildcards count] == 0)) {
        [self release];
        return nil;
    }
    
    return [self initWithSocketAddress:[wildcards objectAtIndex:0]];
}

- (id)initWithSocketAddress:(SocketAddress *)socketAddress
{
    self = [super init];

    if (self) {
        _socketAddress = [socketAddress retain];
    }

    return self;
}

- (void)dealloc
{
    [_socket setDelegate:NULL];
    [_socketAddress release];
    [_socket release];
    [super dealloc];
}

- (BOOL)start:(NSError **)error;
{
    _socket = [[DatagramSocket alloc] init];

    [_socket setDelegate:self];

    if (![_socket bindToSocketAddress:_socketAddress error:error]) {
        return false;
    }

    [_socket startReceiving];

    return true;
}

- (void)datagramSocket:(DatagramSocket *)socket
    didReceiveData:(NSData *)data
    fromSocketAddress:(SocketAddress *)address
{
    NSError *error;

    [_socket sendData:data toSocketAddress:address error:&error];
}

@end
