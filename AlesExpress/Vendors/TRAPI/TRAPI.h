#import <Foundation/Foundation.h>

@interface TRAPI : NSObject

+ (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(void (^)(NSString *accessToken))success
               failure:(void (^)(NSError *error))failure;

+ (void)postTaskWithAccessToken:(NSString *)accessToken
                           Name:(NSString *)name
                    description:(NSString *)description
                 estimatedCosts:(NSNumber *)costInCents
                 pickUpLocation:(NSDictionary *)pickUpLocation
                dropOffLocation:(NSDictionary *)dropOffLocation
                        success:(void (^)())success
                        failure:(void (^)(NSError *error))failure;

@end

