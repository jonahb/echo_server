#include <CoreFoundation/CoreFoundation.h>
#include "EchoServer.h"
#include "Address.h"

int main (int argc, const char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    EchoServer *server;

    if (argc == 1)
    {
        server = [[EchoServer alloc] init];
    }
    else if (argc == 3)
    {
        Address *address;
        NSUInteger port;

        NSString *addressString = [NSString
            stringWithCString:argv[1]
            encoding:[NSString defaultCStringEncoding]
        ];

        if (nil == (address = [Address addressFromString:addressString])) {
            printf("Invalid address\n");
            goto error;
        }

        if (!(port = strtol(argv[2], NULL, 10))) {
            printf("Invalid port\n");
            goto error;
        }

        server = [[EchoServer alloc]
            initWithSocketAddress:[address socketAddressWithPort:port]
        ];
    }
    else
    {
        printf("Usage: %s [address port]\n", argv[0]);
        exit(1);
    }

    NSError *error;

    if (![server start:&error]) {
        printf("Failed to bind to given address and port\n");
        goto error;
    }

    CFRunLoopRun();

    [pool drain];

    return 0;

error:

    [pool drain];

    return 1;
}
