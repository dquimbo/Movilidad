////
////  IPAddressHandler.m
////  Movilidad
////
////  Created by Diego Quimbo on 9/5/23.
////
//
//#import <Foundation/Foundation.h>
//#import "IPAddressHandler.h"
//
//@implementation IPAddressHandler
//
//- (NSString *)getIPAddress {
//    NSMutableString* address = [[NSMutableString alloc] init];
//    //[address appendString:@"An error occurred while trying to get device IP"];
//    
//    struct ifaddrs *interfaces = NULL;
//    struct ifaddrs *temp_addr = NULL;
//    int success = 0;
//    
//    // retrieve the current interfaces - returns 0 on success
//    success = getifaddrs(&interfaces);
//    if (success == 0) {
//        // Loop through linked list of interfaces
//        temp_addr = interfaces;
//        while(temp_addr != NULL) {
//            if(temp_addr->ifa_addr->sa_family == AF_INET) {
//                [address appendString:[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]];
//                [address appendString:@"\n"];
//            }
//            temp_addr = temp_addr->ifa_next;
//        }
//    }
//    // Free memory
//    freeifaddrs(interfaces);
//    
//    if ([address isEqualToString:@""]) {
//        [address appendString:@"-\n"];
//    }
//    
//    return address;
//}
//
//@end
