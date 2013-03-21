//
//  Fraction.m
//  NoteGrind
//
//  Created by Benjamin Selfridge on 3/12/13.
//  Copyright (c) 2013 Benjamin Selfridge. All rights reserved.
//

#import "Fraction.h"

@implementation Fraction

- (Fraction *) initWithNum: (int) n withDenom: (int) d
{
    if (d == 0) d = 1;
    
    self = [super init];
    if (self)
        [self setTo: n over: d];
    
    [self reduce];
    
    return self;
}

- (void) setTo: (int) n over: (int) d
{
    [self setNumerator:n];
    [self setDenominator:d];
}

// my code

- (void) reduce {
    int gcd = [Fraction gcd:[self numerator]:[self denominator]];
    if ([self denominator] < 0) gcd *= -1;
    
    [self setNumerator:[self numerator]/gcd];
    [self setDenominator:[self denominator]/gcd];
}

- (void) normalize {
    if (_numerator == 0 || _denominator == 0) {
        _numerator = 0;
        _denominator = 1;
        return;
    }

    while (_numerator < _denominator) {
        _numerator *= 2;
        if (_numerator == 0 || _denominator == 0) {
            _numerator = 0;
            _denominator = 1;
            return;
        }
    }
    while (2*_denominator <= _numerator) {
        _denominator *= 2;
        if (_numerator == 0 || _denominator == 0) {
            _numerator = 0;
            _denominator = 1;
            return;
        }
    }
    
    [self reduce];
}

-(Fraction *) mulInt: (int)multiplier
{
    Fraction *result = [[Fraction alloc] initWithNum:1 withDenom:1];
    int resultNum, resultDenom;
    
    resultNum = multiplier * [self numerator];
    resultDenom = [self denominator];
    
    [result setTo:resultNum over:resultDenom];
    [result reduce];
    
    return result;
}

-(Fraction *) divInt: (int)dividend
{
    Fraction *result = [[Fraction alloc] initWithNum:1 withDenom:1];
    int resultNum, resultDenom;
    
    resultNum = [self numerator];
    resultDenom = dividend * [self denominator];
    
    [result setTo:resultNum over:resultDenom];
    [result reduce];
    
    return result;
}

-(Fraction *)reciprocal {
    Fraction *result = [[Fraction alloc] init];
    [result setTo:[self denominator] over:[self numerator]];
    [result reduce];
    
    return result;
}

// MathOps category implementation

-(Fraction *) add: (Fraction *) addend
{
    // To add two fractions:
    // a/b + c/d = ((a*d) + (b*c)) / (b * d)
    
    Fraction *result = [[Fraction alloc] init];
    int   resultNum, resultDenom;
    
    resultNum = ([self numerator] * [addend denominator]) +
                ([self denominator] * [addend numerator]);
    resultDenom = [self denominator] * [addend denominator];
    
    [result setTo: resultNum over: resultDenom];
    [result reduce];
    
    return result;
}

-(Fraction *) mul: (Fraction *) multiplier
{
    Fraction *result = [[Fraction alloc] init];
    
    [result setTo: [self numerator] * [multiplier numerator]
             over: [self denominator] * [multiplier denominator]];
    [result reduce];
    
    return result;
}

-(Fraction *) sub: (Fraction *) subtrahend
{
    // To sub two fractions:
    // a/b - c/d = ((a*d) - (b*c)) / (b * d)
    
    return [self add:[subtrahend mulInt:-1]];
}

-(Fraction *) div: (Fraction *) dividend
{
    return [self mul:[dividend reciprocal]];
}

-(double) doubleValue {
    return (double) _numerator / (double) _denominator;
}

+ (int)gcd : (int)x : (int)y {
    x = abs(x);
    y = abs(y);
    
    if (y == 0) {
        return x;
    }

    return [Fraction gcd:y :x%y];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%d/%d", [self numerator], [self denominator]];
}

@end
