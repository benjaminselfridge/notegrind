//
//  Note.m
//  NoteGrind
//
//  Created by Benjamin Selfridge on 3/12/13.
//  Copyright (c) 2013 Benjamin Selfridge. All rights reserved.
//

#import "Note.h"

@implementation Note

- (id)initWithThree:(int)three withFive:(int)five {
    return [self initWithThree:three withFive:five withSeven:0 withEleven:0
                  withThirteen:0 withSeventeen:0 withNineteen:0];
}

- (id)initWithThree:(int)three withFive:(int)five withSeven:(int)seven {
    return [self initWithThree:three withFive:five withSeven:seven withEleven:0
                  withThirteen:0 withSeventeen:0 withNineteen:0];
}

- (id)initWithThree:(int)three withFive:(int)five withSeven:(int)seven
         withEleven:(int)eleven {
    return [self initWithThree:three withFive:five withSeven:seven withEleven:eleven
                  withThirteen:0 withSeventeen:0 withNineteen:0];
}

- (id)initWithThree:(int)three withFive:(int)five withSeven:(int)seven
         withEleven:(int)eleven withThirteen:(int)thirteen {
    return [self initWithThree:three withFive:five withSeven:seven withEleven:eleven
                  withThirteen:thirteen withSeventeen:0 withNineteen:0];
}

- (id)initWithThree:(int)three withFive:(int)five withSeven:(int)seven
         withEleven:(int)eleven withThirteen:(int)thirteen withSeventeen:(int)seventeen {
    return [self initWithThree:three withFive:five withSeven:seven withEleven:eleven
                  withThirteen:thirteen withSeventeen:seventeen withNineteen:0];
}

- (id)initWithThree:(int)three
           withFive:(int)five withSeven:(int)seven
         withEleven:(int)eleven withThirteen:(int)thirteen
      withSeventeen:(int)seventeen withNineteen:(int)nineteen {
    [self setThreePower:three];
    [self setFivePower:five];
    [self setSevenPower:seven];
    [self setElevenPower:eleven];
    [self setThirteenPower:thirteen];
    [self setSeventeenPower:seventeen];
    [self setNineteenPower:nineteen];
    
    return self;
}


- (id) initWithChar:(unichar)letter {
    letter = [[[NSString stringWithCharacters:&letter length:1] uppercaseString] characterAtIndex: 0];
    
    if (letter == 'C') {
        return [self initWithThree:0 withFive:0];
    }
    else if (letter == 'D') {
        return [self initWithThree:2 withFive:0];
    }
    else if (letter == 'E') {
        return [self initWithThree:0 withFive:1];
    }
    else if (letter == 'F') {
        return [self initWithThree:-1 withFive:0];
    }
    else if (letter == 'G') {
        return [self initWithThree:1 withFive:0];
    }
    else if (letter == 'A') {
        return [self initWithThree:-1 withFive:1];
    }
    else if (letter == 'B') {
        return [self initWithThree:1 withFive:1];
    }
    else { // Just default to "C"
        return [self initWithThree:0 withFive:0];
    }
}

- (id) initWithString:(NSString *)noteName {
    if ([noteName length] == 0) {
        return [self initWithChar:'C'];
    }
    
    self = [self initWithChar:[noteName characterAtIndex:0]];
    for (int i = 1; i < [noteName length]; ++i) {
        unichar acc = [noteName characterAtIndex:i];
        if (acc == '#')
            [self sharpen];
        else if (acc == 'b')
            [self flatten];
        else if (acc == '+')
            [self plussen];
        else if (acc == '-')
            [self minussen];
        else if (acc == '7')
            [self upsevenen];
        else if (acc == 'L')
            [self downsevenen];
        else if (acc == '^')
            [self uparrowen];
        else if (acc == 'v')
            [self downarrowen];
        else if (acc == 'T')
            [self upthirteenen];
        else if (acc == 't')
            [self downthirteenen];
        else if (acc == 'S')
            [self upseventeenen];
        else if (acc == 's')
            [self downseventeenen];
        else if (acc == 'N')
            [self upnineteenen];
        else if (acc == 'n')
            [self downnineteenen];
    }
    
    return self;
}

- (id) initWithFraction:(Fraction *)frac withFlag:(BOOL *)flag {
    self = [self initWithChar:'C'];
    
    int num = [frac numerator];
    int denom = [frac denominator];
    
    while (num % 3 == 0) {
        num /= 3;
        ++_threePower;
    }
    while (denom % 3 == 0) {
        denom /= 3;
        --_threePower;
    }
    while (num % 5 == 0) {
        num /= 5;
        ++_fivePower;
    }
    while (denom % 5 == 0) {
        denom /= 5;
        --_fivePower;
    }
    while (num % 7 == 0) {
        num /= 7;
        ++_sevenPower;
    }
    while (denom % 7 == 0) {
        denom /= 7;
        --_sevenPower;
    }
    while (num % 11 == 0) {
        num /= 11;
        ++_elevenPower;
    }
    while (denom % 11 == 0) {
        denom /= 11;
        --_elevenPower;
    }
    while (num % 13 == 0) {
        num /= 13;
        ++_thirteenPower;
    }
    while (denom % 13 == 0) {
        denom /= 13;
        --_thirteenPower;
    }
    while (num % 17 == 0) {
        num /= 17;
        ++_seventeenPower;
    }
    while (denom % 17 == 0) {
        denom /= 17;
        --_seventeenPower;
    }
    while (num % 19 == 0) {
        num /= 19;
        ++_nineteenPower;
    }
    while (denom % 19 == 0) {
        denom /= 19;
        --_nineteenPower;
    }
    
    Fraction *shouldBeOne = [[Fraction alloc] initWithNum:num withDenom:denom];
    [shouldBeOne normalize];
    
    // Set the warning flag to YES if fraction include unsupported prime
    if ([shouldBeOne numerator] != [shouldBeOne denominator]) {
        NSLog(@"%d / %d", [shouldBeOne numerator], [shouldBeOne denominator]);
        *flag = YES;
    }
    else {
        *flag = NO;
    }
    
    return self;
}

- (BOOL)inRange:(Note *)baseNote {
    int baseThree = [baseNote threePower];
    int baseFive = [baseNote fivePower];
    int targetThree = [self threePower];
    int targetFive = [self fivePower];
    
    if (targetThree - baseThree == -1) {
        return (targetFive - baseFive == 1) || (targetFive - baseFive == 0);
    }
    else if (targetThree - baseThree == 0) {
        return (targetFive - baseFive == 1) || (targetFive - baseFive == 0);
    }
    else if (targetThree - baseThree == 1) {
        return (targetFive - baseFive == 1) || (targetFive - baseFive == 0);
    }
    else if (targetThree - baseThree == 2){
        return (targetFive - baseFive == 0);
    }
    else {
        return NO;
    }
}

- (Note *)add:(Note *)otherNote {
    int three = [self threePower] + [otherNote threePower];
    int five = [self fivePower] + [otherNote fivePower];
    int seven = [self sevenPower] + [otherNote sevenPower];
    int eleven = [self elevenPower] + [otherNote elevenPower];
    int thirteen = [self thirteenPower] + [otherNote thirteenPower];
    int seventeen = [self seventeenPower] + [otherNote seventeenPower];
    int nineteen = [self nineteenPower] + [otherNote nineteenPower];
    
    Note *sum = [[Note alloc] initWithThree:three withFive:five withSeven:seven withEleven:eleven
                               withThirteen:thirteen withSeventeen:seventeen withNineteen:nineteen];
    
    return sum;
}

- (Note *)sub:(Note *)otherNote {
    int three = [self threePower] - [otherNote threePower];
    int five = [self fivePower] - [otherNote fivePower];
    int seven = [self sevenPower] - [otherNote sevenPower];
    int eleven = [self elevenPower] - [otherNote elevenPower];
    int thirteen = [self thirteenPower] - [otherNote thirteenPower];
    int seventeen = [self seventeenPower] - [otherNote seventeenPower];
    int nineteen = [self nineteenPower] - [otherNote nineteenPower];
    
    return [[Note alloc] initWithThree:three withFive:five withSeven:seven withEleven:eleven
                          withThirteen:thirteen withSeventeen:seventeen withNineteen:nineteen];
}

- (Fraction *)fraction {
    Fraction *frac = [[Fraction alloc] initWithNum:1 withDenom:1];
    int threePower = _threePower;
    int fivePower = _fivePower;
    int sevenPower = _sevenPower;
    int elevenPower = _elevenPower;
    int thirteenPower = _thirteenPower;
    int seventeenPower = _seventeenPower;
    int nineteenPower = _nineteenPower;

    while (threePower > 0) {
        frac = [frac mulInt:3];
        --threePower;
    }
    while (threePower < 0) {
        frac = [frac divInt:3];
        ++threePower;
    }
    while (fivePower > 0) {
        frac = [frac mulInt:5];
        --fivePower;
    }
    while (fivePower < 0) {
        frac = [frac divInt:5];
        ++fivePower;
    }
    while (sevenPower > 0) {
        frac = [frac mulInt:7];
        --sevenPower;
    }
    while (sevenPower < 0) {
        frac = [frac divInt:7];
        ++sevenPower;
    }
    while (elevenPower > 0) {
        frac = [frac mulInt:11];
        --elevenPower;
    }
    while (elevenPower < 0) {
        frac = [frac divInt:11];
        ++elevenPower;
    }
    while (thirteenPower > 0) {
        frac = [frac mulInt:13];
        --thirteenPower;
    }
    while (thirteenPower < 0) {
        frac = [frac divInt:13];
        ++thirteenPower;
    }
    while (seventeenPower > 0) {
        frac = [frac mulInt:17];
        --seventeenPower;
    }
    while (seventeenPower < 0) {
        frac = [frac divInt:17];
        ++seventeenPower;
    }
    while (nineteenPower > 0) {
        frac = [frac mulInt:19];
        --nineteenPower;
    }
    while (nineteenPower < 0) {
        frac = [frac divInt:19];
        ++nineteenPower;
    }
    
    [frac normalize];
    return frac;
}

- (NSString *) description {
    
    int sharps, plusses;
    int upsevens = _sevenPower,
        uparrows = _elevenPower,
        upthirteens = _thirteenPower,
        upseventeens = _seventeenPower,
        upnineteens = _nineteenPower;
    
    int c3 = _threePower + 2*_sevenPower - _elevenPower - _seventeenPower + _nineteenPower;
    int c5 = _fivePower - _sevenPower - _thirteenPower + 2*_seventeenPower - _nineteenPower;
    
    sharps = -1*c3 + 4*(floor((double)(2*c3 + c5) / 7.0));
    plusses = floor((double)(2*c3 + c5)/7);
    int n = (2*c3 + c5) % 7;
    if (n < 0) n += 7;
    
    char letter = '\0';
    
    switch (n) {
        case 0:
            letter = 'C';
            break;
        case 1:
            letter = 'E';
            break;
        case 2:
            letter = 'G';
            sharps += 1;
            break;
        case 3:
            letter = 'B';
            sharps += 1;
            break;
        case 4:
            letter = 'D';
            sharps += 2;
            break;
        case 5:
            letter = 'F';
            sharps += 3;
            plusses += 1;
            break;
        case 6:
            letter = 'A';
            sharps += 3;
            plusses += 1;
        default:
            break;
    }
    
    NSMutableString *noteString = [[NSMutableString alloc] init];

    [noteString appendFormat:@"%c", letter];

    for (int i = 0; i < sharps; ++i) [noteString appendFormat:@"%c", '#'];
    for (int i = 0; i > sharps; --i) [noteString appendFormat:@"%c", 'b'];
    for (int i = 0; i < plusses; ++i) [noteString appendFormat:@"%c", '+'];
    for (int i = 0; i > plusses; --i) [noteString appendFormat:@"%c", '-'];
    for (int i = 0; i < upsevens; ++i) [noteString appendFormat:@"%c", '7'];
    for (int i = 0; i > upsevens; --i) [noteString appendFormat:@"%c", 'L'];
    for (int i = 0; i < uparrows; ++i) [noteString appendFormat:@"%c", '^'];
    for (int i = 0; i > uparrows; --i) [noteString appendFormat:@"%c", 'v'];
    for (int i = 0; i < upthirteens; ++i) [noteString appendFormat:@"%c", 'T'];
    for (int i = 0; i > upthirteens; --i) [noteString appendFormat:@"%c", 't'];
    for (int i = 0; i < upseventeens; ++i) [noteString appendFormat:@"%c", 'S'];
    for (int i = 0; i > upseventeens; --i) [noteString appendFormat:@"%c", 's'];
    for (int i = 0; i < upnineteens; ++i) [noteString appendFormat:@"%c", 'N'];
    for (int i = 0; i > upnineteens; --i) [noteString appendFormat:@"%c", 'n'];

    return noteString;
}

- (void) sharpen {
    _threePower += -1;
    _fivePower += 2;
}
- (void) flatten {
    _threePower += 1;
    _fivePower += -2;
}   
- (void) plussen {
    _threePower += 4;
    _fivePower += -1;
}
- (void) minussen {
    _threePower += -4;
    _fivePower += 1;
}
- (void) upsevenen {
    _threePower += -2;
    _fivePower += 1;
    _sevenPower += 1;
}
- (void) downsevenen {
    _threePower += 2;
    _fivePower += -1;
    _sevenPower += -1;
}
- (void) uparrowen {
    _threePower += 1;
    _elevenPower += 1;
}
- (void) downarrowen {
    _threePower += -1;
    _elevenPower += -1;
}
- (void) upthirteenen {
    _fivePower += 1;
    _thirteenPower += 1;
}
- (void) downthirteenen {
    _fivePower += -1;
    _thirteenPower += -1;
}
- (void) upseventeenen {
    _threePower += 1;
    _fivePower -= 2;
    _seventeenPower += 1;
}
- (void) downseventeenen {
    _threePower -= 1;
    _fivePower += 2;
    _seventeenPower -= 1;
}
- (void) upnineteenen {
    _threePower -= 1;
    _fivePower += 1;
    _nineteenPower += 1;
}
- (void) downnineteenen {
    _threePower += 1;
    _fivePower -= 1;
    _nineteenPower -= 1;
}

@end
