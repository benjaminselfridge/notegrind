//
//  Scale.h
//  NoteGrind
//
//  Created by Benjamin Selfridge on 3/15/13.
//  Copyright (c) 2013 Benjamin Selfridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fraction.h"

@interface Scale : NSObject

@property NSString *name;
@property NSMutableArray *fractions;

- (id) initWithName : (NSString *) name;
- (void) addFraction: (int) num over: (int) denom;
- (Fraction *) nthDegree : (int) degree;

@end
