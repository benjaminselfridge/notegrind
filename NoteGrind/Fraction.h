//
//  Fraction.h
//  NoteGrind
//
//  Created by Benjamin Selfridge on 3/12/13.
//  Copyright (c) 2013 Benjamin Selfridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fraction : NSObject

@property(assign) int numerator;
@property(assign) int denominator;

- (id)initWithNum : (int)num withDenom: (int)denom;
- (void) reduce;
- (void) normalize;
- (NSString *)description;

- (void) setTo: (int) n over: (int) d;

- (Fraction *)reciprocal;
- (Fraction *)mulInt : (int)multiplier;
- (Fraction *)divInt : (int)dividend;

- (Fraction *)add : (Fraction *)addend;
- (Fraction *)mul : (Fraction *)multiplier;
- (Fraction *)sub : (Fraction *)subtrahend;
- (Fraction *)div : (Fraction *)dividend;

- (double) doubleValue;

+ (int)gcd : (int)x : (int)y ;

@end
