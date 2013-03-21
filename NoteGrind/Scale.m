//
//  Scale.m
//  NoteGrind
//
//  Created by Benjamin Selfridge on 3/15/13.
//  Copyright (c) 2013 Benjamin Selfridge. All rights reserved.
//

#import "Scale.h"
#import "Fraction.h"

@implementation Scale

- (id) initWithName:(NSString *)name {
    self.name = [[NSString alloc] initWithString:name];
    self.fractions = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) addFraction:(int)num over:(int)denom {
    [self.fractions addObject:[[Fraction alloc] initWithNum:num withDenom:denom]];
}

- (Fraction *) nthDegree:(int)degree {
    return [self.fractions objectAtIndex:degree];
}

@end
