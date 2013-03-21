//
//  Note.h
//  NoteGrind
//
//  Created by Benjamin Selfridge on 3/12/13.
//  Copyright (c) 2013 Benjamin Selfridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fraction.h"

@interface Note : NSObject

@property(assign)int threePower;
@property(assign)int fivePower;
@property(assign)int sevenPower;
@property(assign)int elevenPower;
@property(assign)int thirteenPower;
@property(assign)int seventeenPower;
@property(assign)int nineteenPower;

// Basic Constructors
- (id)initWithThree:(int)three withFive:(int)five;
- (id)initWithThree:(int)three withFive:(int)five withSeven:(int)seven;
- (id)initWithThree:(int)three withFive:(int)five withSeven:(int)seven
         withEleven:(int)eleven;
- (id)initWithThree:(int)three withFive:(int)five withSeven:(int)seven
         withEleven:(int)eleven withThirteen:(int)thirteen;
- (id)initWithThree:(int)three withFive:(int)five withSeven:(int)seven
         withEleven:(int)eleven withThirteen:(int)thirteen withSeventeen:(int)seventeen;
- (id)initWithThree:(int)three withFive:(int)five withSeven:(int)seven
       withEleven:(int)eleven withThirteen:(int)thirteen withSeventeen:(int)seventeen
       withNineteen:(int) nineteen;

// String Constructors
- (id) initWithChar:(unichar)letter;
- (id) initWithString:(NSString *)noteName;

// Fraction Constructor
- (id) initWithFraction:(Fraction *)frac withFlag: (BOOL *)flag;

// Note representations
- (Fraction *)fraction;
- (NSString *)description;

// adding/subtracting notes
- (Note *)add:(Note *)otherNote;
- (Note *)sub:(Note *)otherNote;

// modifying notes with accidentals
- (void) sharpen;
- (void) flatten;
- (void) plussen;
- (void) minussen;
- (void) upsevenen;
- (void) downsevenen;
- (void) uparrowen;
- (void) downarrowen;
- (void) upthirteenen;
- (void) downthirteenen;
- (void) upseventeenen;
- (void) downseventeenen;
- (void) upnineteenen;
- (void) downnineteenen;

@end
