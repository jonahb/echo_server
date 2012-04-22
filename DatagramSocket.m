#import "DatagramSocket.h"
#import "SocketAddress.h"


void SocketCallback(
    CFSocketRef socket,
    CFSocketCallBackType callbackType,
    CFDataRef address,
    const void *data,
    void *info
);



@interface DatagramSocket()

- (void)handleSocketCallbackWithType:(CFSocketCallBackType)type
    address:(CFDataRef)address
    data:(const void *)data;

- (void)handleSocketDataCallbackWithAddress:(CFDataRef)address
    data:(CFDataRef)data;

+ (NSError *)errorFromSocketError:(CFSocketError)socketError;

@end



@implementation DatagramSocket

@synthesize delegate = _delegate;

- (id) init
{
    self = [super init];

    if (self)
    {
        _runLoopSource = NULL;

        CFSocketContext socketContext;

        socketContext.version = 1.0;
        socketContext.info = self;
        socketContext.copyDescription = NULL;
        socketContext.release = NULL;
        socketContext.retain = NULL;

        _socket = CFSocketCreate(
            kCFAllocatorDefault,
            PF_INET,
            SOCK_DGRAM,
            IPPROTO_UDP,
            kCFSocketDataCallBack,
            SocketCallback,
            &socketContext
        );

        if (NULL == _socket) {
            [self release];
            return nil;
        }

        CFSocketNativeHandle native = CFSocketGetNative(_socket);

        int flags = fcntl(native, F_GETFL);

        if (fcntl(native, F_SETFL, flags | O_NONBLOCK)) {
            [self release];
            return nil;
        }
    }

    return self;
}

- (void)dealloc
{
    [self stopReceiving];
    CFSocketInvalidate(_socket);
    CFRelease(_socket);
    [super dealloc];
}

- (BOOL)bindToSocketAddress:(SocketAddress *)socketAddress
    error:(NSError **)error
{
    CFSocketError status = CFSocketSetAddress(
        _socket,
        (CFDataRef)[socketAddress convertToData]
    );

    *error = [[self class] errorFromSocketError:status];

    return (nil == *error);
}

- (void)startReceiving
{
    if (NULL != _runLoopSource) {
        return;
    }

    _runLoopSource = CFSocketCreateRunLoopSource(
        kCFAllocatorDefault,
        _socket,
        0
    );

    CFRunLoopAddSource(
        CFRunLoopGetCurrent(),
        _runLoopSource,
        kCFRunLoopDefaultMode
    );
}

- (void)stopReceiving
{
    if (NULL == _runLoopSource) {
        return;
    }

    CFRunLoopRemoveSource(
        CFRunLoopGetCurrent(),
        _runLoopSource,
        kCFRunLoopDefaultMode
    );

    CFRelease(_runLoopSource);

    _runLoopSource = NULL;
}

- (BOOL)sendData:(NSData *)data
    toSocketAddress:(SocketAddress *)address
    error:(NSError **)error
{
    CFSocketError status = CFSocketSendData(
        _socket,
        (CFDataRef)[address convertToData],
        (CFDataRef)data,
        -1
    );

    *error = [[self class] errorFromSocketError:status];

    return (nil == *error);
}

- (void)handleSocketDataCallbackWithAddress:(CFDataRef)address
    data:(CFDataRef)data
{
    SocketAddress *socketAddress = [SocketAddress
        socketAddressFromData:(NSData *)address
    ];

    [_delegate
        datagramSocket:self
        didReceiveData:(NSData *)data 
        fromSocketAddress:socketAddress
    ];
}


- (void)handleSocketCallbackWithType:(CFSocketCallBackType)type
    address:(CFDataRef)address
    data:(const void *)data
{
    switch (type)
    {
        case kCFSocketDataCallBack:
        {
            [self handleSocketDataCallbackWithAddress:address data:data];
            break;
        }
        default:
        {
            [NSException
                raise:@"UnexpectedSocketCallbackType"
                format:@"CFSocket invoked something other than a data callback"
            ];
        }
    }
}

+ (NSError *)errorFromSocketError:(CFSocketError)socketError
{
    if (kCFSocketSuccess == socketError) {
        return nil;
    }

    NSInteger code;

    switch (socketError) 
    {
    case kCFSocketTimeout:
        code = DatagramSocketTimeout;
        break;
    default:
        code = DatagramSocketUnknownError;
        break;
    }

    return [NSError
        errorWithDomain:@"DatagramSocketErrorDomain"
        code:code
        userInfo:NULL
    ];
}

@end



void SocketCallback(
    CFSocketRef socket,
    CFSocketCallBackType callbackType,
    CFDataRef address,
    const void *data,
    void *info)
{
    [(DatagramSocket *)info handleSocketCallbackWithType:callbackType
        address:address
        data:data
    ];
};
