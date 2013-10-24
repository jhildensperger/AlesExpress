//
//  Beer.h
//
//  Created by   on 9/21/12
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



@interface Beer : NSManagedObject

@property (nonatomic) NSString *imageUrl;
@property (nonatomic) NSString *serving;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSNumber *abv;
@property (nonatomic) NSString *descriptionText;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *url;


@end

