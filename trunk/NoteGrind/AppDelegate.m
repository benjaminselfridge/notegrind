    ///
//  AppDelegate.m
//  NoteGrind
//
//  Created by Benjamin Selfridge on 3/12/13.
//  Copyright (c) 2013 Benjamin Selfridge. All rights reserved.
//

#import "AppDelegate.h"
#import "Fraction.h"
#import "Note.h"
#import <AudioToolbox/AudioToolbox.h>

#define ARC4RANDOM_MAX      0x100000000

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Initialize ToneGenerator
    self.tg = [[TonePlayer alloc] init];
    
    // Set up appearance
    CGRect screenRect = [[NSScreen mainScreen] frame];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    NSRect windowFrame = [self.window frame];
    NSRect scaleFrame = [self.scalePanel frame];
    NSRect timbreFrame = [self.timbrePanel frame];
    NSRect newWindowFrame = NSMakeRect((screenWidth - windowFrame.size.width)/2, (screenHeight - windowFrame.size.height)/2, windowFrame.size.width, windowFrame.size.height);
    NSRect newScaleFrame = NSMakeRect(newWindowFrame.origin.x + newWindowFrame.size.width+5, newWindowFrame.origin.y, scaleFrame.size.width, scaleFrame.size.height);
    NSRect newTimbreFrame = NSMakeRect(newWindowFrame.origin.x - timbreFrame.size.width - 5, newWindowFrame.origin.y + newWindowFrame.size.height - timbreFrame.size.height, timbreFrame.size.width, timbreFrame.size.height);
    
    [self.window setFrame:newWindowFrame display:YES];
    [self.scalePanel setFrame:newScaleFrame display:YES];
    [self.timbrePanel setFrame:newTimbreFrame display:YES];
    
    [self.window setBackgroundColor:[NSColor whiteColor]];
    [self.scalePanel setBackgroundColor:[NSColor whiteColor]];
    [self.timbrePanel setBackgroundColor:[NSColor whiteColor]];
    [self.warningLabel setTextColor:[NSColor redColor]];
    
    [self.scaleField setFont:[NSFont fontWithName:@"Andale Mono" size:16]];
    [self.baseNoteField setFont:[NSFont fontWithName:@"Andale Mono" size:16]];
    [self.targetNoteField setFont:[NSFont fontWithName:@"Andale Mono" size:16]];
    [self.fractionField setFont:[NSFont fontWithName:@"Andale Mono" size:16]];
    
    // Initialize scales
    self.scales = [[NSMutableArray alloc] init];
    [self loadScales];
    
    // Set fields
    
    BOOL unsupportedFrac;
    Fraction *frac = [[Fraction alloc] initWithNum:3 withDenom:2];
    [frac normalize];
    
    Note *baseNote = [[Note alloc] initWithString:@"C"];
    Note *noteAddend = [[Note alloc] initWithFraction:frac withFlag:&unsupportedFrac];
    Note *targetNote = [baseNote add:noteAddend];
    
    [self.baseNoteField setStringValue:[baseNote description]];
    [self.targetNoteField setStringValue:[targetNote description]];
    [self.fractionField setStringValue:[frac description]];
    double centsAbove = 1200*log2([[[targetNote sub:baseNote] fraction] doubleValue]);
    [self.centsLabel setStringValue:[NSString stringWithFormat:@"%3.2f cents", centsAbove]];
    
    [self updateScale];
    [self updateFrequencies];
    
    // Turn both tones on
    [self toggleBaseSound:self];
    [self toggleTargetSound:self];
}

- (IBAction)setBaseNote:(id)sender {
    Note *baseNote = [[Note alloc] initWithString:[self.baseNoteField stringValue]];
    Note *targetNote = [[Note alloc] initWithString:[self.targetNoteField stringValue]];
    
    [self.baseNoteField setStringValue:[baseNote description]];
    [self.targetNoteField setStringValue:[targetNote description]];
    [self.fractionField setStringValue:[[[targetNote sub:baseNote] fraction] description]];
    double centsAbove = 1200*log2([[[targetNote sub:baseNote] fraction] doubleValue]);
    [self.centsLabel setStringValue:[NSString stringWithFormat:@"%3.2f cents", centsAbove]];
    
    [self updateScale];
    [self updateFrequencies];
    //[self setFraction:self];
    [self updateScale];
}

- (IBAction)setTargetNote:(id)sender {
    Note *baseNote = [[Note alloc] initWithString:[self.baseNoteField stringValue]];
    Note *targetNote = [[Note alloc] initWithString:[self.targetNoteField stringValue]];
    
    [self.baseNoteField setStringValue:[baseNote description]];
    [self.targetNoteField setStringValue:[targetNote description]];
    [self.fractionField setStringValue:[[[targetNote sub:baseNote] fraction] description]];
    double centsAbove = 1200*log2([[[targetNote sub:baseNote] fraction] doubleValue]);
    [self.centsLabel setStringValue:[NSString stringWithFormat:@"%3.2f cents", centsAbove]];
    
    [self updateFrequencies];
}

- (IBAction)setFraction:(id)sender {
    
    NSString *fracString = [self.fractionField stringValue];
    NSArray *fracSplit = [fracString componentsSeparatedByString:@"/"];
    
    Fraction *frac;
    
    int num, denom;
    if ([fracSplit count] >= 2) {
        num = ([fracSplit[0] intValue] == 0 ? 1 : [fracSplit[0] intValue]);
        denom = ([fracSplit[1] intValue] == 0 ? 1 : [fracSplit[1] intValue]);
    }
    else if ([fracSplit count] == 1) {
        num = ([fracSplit[0] intValue] == 0 ? 1 : [fracSplit[0] intValue]);
        denom = 1;
    }
    else {
        num = denom = 1;
    }
    frac = [[Fraction alloc] initWithNum:num withDenom:denom];
    
    [frac normalize];
    
    BOOL unsupportedFrac = NO;
    Note *noteAddend = [[Note alloc] initWithFraction:frac withFlag:&unsupportedFrac];
    if (unsupportedFrac) {
        [self.warningLabel setStringValue:@"Warning: unsupported prime"];
    }
    else {
        [self.warningLabel setStringValue:@""];
    }
    
    Note *baseNote = [[Note alloc] initWithString:[self.baseNoteField stringValue]];
    Note *targetNote = [baseNote add:noteAddend];
    
    [self.baseNoteField setStringValue:[baseNote description]];
    [self.targetNoteField setStringValue:[targetNote description]];
    [self.fractionField setStringValue:[frac description]];
    double centsAbove = 1200*log2([frac doubleValue]);
    [self.centsLabel setStringValue:[NSString stringWithFormat:@"%3.2f cents", centsAbove]];
    
    [self updateFrequencies];
}

- (IBAction)setScale:(id)sender {
    [self updateScale];
}

- (void) updateFrequencies {
    Note *cNote = [[Note alloc] initWithChar:'C'];
    Note *baseNote = [[Note alloc] initWithString:[self.baseNoteField stringValue]];
    Note *targetNote = [[Note alloc] initWithString:[self.targetNoteField stringValue]];
    
    double baseDifference = [[[baseNote sub:cNote] fraction] doubleValue];
    double targetDifference = [[[targetNote sub:baseNote] fraction] doubleValue] * baseDifference;
    
    double cFreq = 264.0;
    double baseNoteFreq = cFreq * baseDifference;
    double targetNoteFreq = cFreq * targetDifference;
    
    if (self.tg) {
        self.tg->frequency1 = baseNoteFreq;
        self.tg->frequency2 = targetNoteFreq;
    }
}

- (void) updateOvertones {
    self.tg->overtones[1] = [self.secondHarmonicSlider doubleValue];
    self.tg->overtones[2] = [self.thirdHarmonicSlider doubleValue];
    self.tg->overtones[3] = [self.fourthHarmonicSlider doubleValue];
    self.tg->overtones[4] = [self.fifthHarmonicSlider doubleValue];
    self.tg->overtones[5] = [self.sixthHarmonicSlider doubleValue];
    self.tg->overtones[6] = [self.seventhHarmonicSlider doubleValue];
    self.tg->overtones[7] = [self.eighthHarmonicSlider doubleValue];
    self.tg->overtones[8] = [self.ninthHarmonicSlider doubleValue];
    self.tg->overtones[9] = [self.tenthHarmonicSlider doubleValue];
    self.tg->overtones[10] = [self.eleventhHarmonicSlider doubleValue];
}

- (IBAction)togglePlay:(id)sender {
    [self.toggleScaleButton setState:NSOffState];
    
    [self setTargetNote:self];
    [self updateFrequencies];
    
    BOOL on = [self.togglePlayButton state] == NSOnState;
    [self.tg togglePlay:on];
}

- (IBAction)toggleBaseSound:(id)sender {
    if ([self.baseSoundCheck state] == NSOnState) {
        self.tg->channel1_on = YES;
    }
    else {
        self.tg->channel1_on = NO;
    }
}

- (IBAction)toggleTargetSound:(id)sender {
    if ([self.targetSoundCheck state] == NSOnState) {
        self.tg->channel2_on = YES;
    }
    else {
        self.tg->channel2_on = NO;
    }
}

- (IBAction)setOvertone:(id)sender {
    NSSlider *slider = (NSSlider *) sender;
    long overtone = [slider tag];
    
    self.tg->overtones[overtone-1] = [slider doubleValue];
}

- (IBAction)zeroOvertones:(id)sender {
    [self.secondHarmonicSlider setDoubleValue:0.0];
    [self.thirdHarmonicSlider setDoubleValue:0.0];
    [self.fourthHarmonicSlider setDoubleValue:0.0];
    [self.fifthHarmonicSlider setDoubleValue:0.0];
    [self.sixthHarmonicSlider setDoubleValue:0.0];
    [self.seventhHarmonicSlider setDoubleValue:0.0];
    [self.eighthHarmonicSlider setDoubleValue:0.0];
    [self.ninthHarmonicSlider setDoubleValue:0.0];
    [self.tenthHarmonicSlider setDoubleValue:0.0];
    [self.eleventhHarmonicSlider setDoubleValue:0.0];
    
    [self updateOvertones];
}

- (IBAction)randomizeOvertones:(id)sender {
    [self.secondHarmonicSlider setDoubleValue:((double)arc4random() / ARC4RANDOM_MAX)];
    [self.thirdHarmonicSlider setDoubleValue:((double)arc4random() / ARC4RANDOM_MAX)];
    [self.fourthHarmonicSlider setDoubleValue:((double)arc4random() / ARC4RANDOM_MAX)];
    [self.fifthHarmonicSlider setDoubleValue:((double)arc4random() / ARC4RANDOM_MAX)];
    [self.sixthHarmonicSlider setDoubleValue:((double)arc4random() / ARC4RANDOM_MAX)];
    [self.seventhHarmonicSlider setDoubleValue:((double)arc4random() / ARC4RANDOM_MAX)];
    [self.eighthHarmonicSlider setDoubleValue:((double)arc4random() / ARC4RANDOM_MAX)];
    [self.ninthHarmonicSlider setDoubleValue:((double)arc4random() / ARC4RANDOM_MAX)];
    [self.tenthHarmonicSlider setDoubleValue:((double)arc4random() / ARC4RANDOM_MAX)];
    [self.eleventhHarmonicSlider setDoubleValue:((double)arc4random() / ARC4RANDOM_MAX)];
    
    [self updateOvertones];
}

- (IBAction)toggleScale:(id)sender {
    [self.togglePlayButton setState:NSOffState];
    
    BOOL on = [self.toggleScaleButton state] == NSOnState;
    if (on) {
        Note *cNote = [[Note alloc] initWithChar:'C'];
        Note *baseNote = [[Note alloc] initWithString:[self.baseNoteField stringValue]];
        double baseDifference = [[[baseNote sub:cNote] fraction] doubleValue];
        double cFreq = 264.0;
        double baseNoteFreq = cFreq * baseDifference;
        
        NSString *scaleType = [self.scaleMenu.selectedItem title];
        
        Scale *scale;
        int i;
        for (i=0; i < [self.scales count]; ++i) {
            if ([scaleType isEqualToString:[[self.scales objectAtIndex:i] name]]) {
                scale = [self.scales objectAtIndex:i];
                break;
            }
        }
        
        if (i == [self.scales count])  {
            NSLog(@"Unrecognized scale");
            return;
        }
        
        self.tg->frequency1 = baseNoteFreq;
        self.tg->frequency2 = baseNoteFreq;
        
        [self.tg togglePlay:YES];
        
        for (int i=0; i < [scale.fractions count]; ++i) {
            Fraction *frac = (Fraction *)[scale.fractions objectAtIndex:i];
            self.tg->frequency2 = baseNoteFreq * [frac doubleValue];

            sleep(1);
        }
        // play final note
        self.tg->frequency2 = baseNoteFreq * 2.0;
        sleep(1);
        
        [self.toggleScaleButton setState:NSOffState];
        [self.tg togglePlay:NO];
    }
    else {
        [self.tg togglePlay:NO];
    }
}

- (IBAction)showScales:(id)sender {
}

- (void) loadScales {
    
    Scale *majorScale = [[Scale alloc] initWithName:@"Major (5-Limit)"];
    [majorScale addFraction:1 over:1];
    [majorScale addFraction:9 over:8];
    [majorScale addFraction:5 over:4];
    [majorScale addFraction:4 over:3];
    [majorScale addFraction:3 over:2];
    [majorScale addFraction:5 over:3];
    [majorScale addFraction:15 over:8];
    
    [self.scales addObject:majorScale];
    
    Scale *minorScale = [[Scale alloc] initWithName:@"Minor (5-Limit)"];
    [minorScale addFraction:1 over:1];
    [minorScale addFraction:9 over:8];
    [minorScale addFraction:6 over:5];
    [minorScale addFraction:4 over:3];
    [minorScale addFraction:3 over:2];
    [minorScale addFraction:8 over:5];
    [minorScale addFraction:9 over:5];
    
    [self.scales addObject:minorScale];
    
    Scale *pythagoreanMajor = [[Scale alloc] initWithName:@"Major (Pythagorean)"];
    [pythagoreanMajor addFraction:1 over:1];
    [pythagoreanMajor addFraction:9 over:8];
    [pythagoreanMajor addFraction:81 over:64];
    [pythagoreanMajor addFraction:4 over:3];
    [pythagoreanMajor addFraction:3 over:2];
    [pythagoreanMajor addFraction:27 over:16];
    [pythagoreanMajor addFraction:243 over:128];
    
    [self.scales addObject:pythagoreanMajor];
    
    Scale *pythagoreanMinor = [[Scale alloc] initWithName:@"Minor Pythagorean)"];
    [pythagoreanMinor addFraction:1 over:1];
    [pythagoreanMinor addFraction:9 over:8];
    [pythagoreanMinor addFraction:32 over:27];
    [pythagoreanMinor addFraction:4 over:3];
    [pythagoreanMinor addFraction:3 over:2];
    [pythagoreanMinor addFraction:128 over:81];
    [pythagoreanMinor addFraction:16 over:9];
    
    [self.scales addObject:pythagoreanMinor];
    
    Scale *chromatic7limit = [[Scale alloc] initWithName:@"Seven-Limit Chromatic"];
    [chromatic7limit addFraction:1 over:1];
    [chromatic7limit addFraction:16 over:15];
    [chromatic7limit addFraction:9 over:8];
    [chromatic7limit addFraction:6 over:5];
    [chromatic7limit addFraction:5 over:4];
    [chromatic7limit addFraction:4 over:3];
    [chromatic7limit addFraction:7 over:5];
    [chromatic7limit addFraction:3 over:2];
    [chromatic7limit addFraction:8 over:5];
    [chromatic7limit addFraction:5 over:3];
    [chromatic7limit addFraction:9 over:5];
    [chromatic7limit addFraction:15 over:8];
    
    [self.scales addObject:chromatic7limit];
    
    Scale *johnston12 = [[Scale alloc] initWithName:@"Johnston 12 (Suite for Microtonal Piano)"];
    [johnston12 addFraction:1 over:1];
    [johnston12 addFraction:17 over:16];
    [johnston12 addFraction:9 over:8];
    [johnston12 addFraction:19 over:16];
    [johnston12 addFraction:5 over:4];
    [johnston12 addFraction:21 over:16];
    [johnston12 addFraction:11 over:8];
    [johnston12 addFraction:3 over:2];
    [johnston12 addFraction:13 over:8];
    [johnston12 addFraction:27 over:16];
    [johnston12 addFraction:7 over:4];
    [johnston12 addFraction:15 over:8];
    
    [self.scales addObject:johnston12];
    
    Scale *johnston25 = [[Scale alloc] initWithName:@"Johnston 25"];
    [johnston25 addFraction:1 over:1];
    [johnston25 addFraction:25 over:24];
    [johnston25 addFraction:135 over:128];
    [johnston25 addFraction:16 over:15];
    [johnston25 addFraction:10 over:9];
    [johnston25 addFraction:9 over:8];
    [johnston25 addFraction:75 over:64];
    [johnston25 addFraction:6 over:5];
    [johnston25 addFraction:5 over:4];
    [johnston25 addFraction:81 over:64];
    [johnston25 addFraction:32 over:25];
    [johnston25 addFraction:4 over:3];
    [johnston25 addFraction:27 over:20];
    [johnston25 addFraction:45 over:32];
    [johnston25 addFraction:36 over:25];
    [johnston25 addFraction:3 over:2];
    [johnston25 addFraction:25 over:16];
    [johnston25 addFraction:8 over:5];
    [johnston25 addFraction:5 over:3];
    [johnston25 addFraction:27 over:16];
    [johnston25 addFraction:225 over:128];
    [johnston25 addFraction:16 over:9];
    [johnston25 addFraction:9 over:5];
    [johnston25 addFraction:15 over:8];
    [johnston25 addFraction:48 over:25];
    
    [self.scales addObject:johnston25];
    
    Scale *partch43 = [[Scale alloc] initWithName:@"Partch 43"];
    [partch43 addFraction:1 over:1];
    [partch43 addFraction:81 over:80];
    [partch43 addFraction:33 over:32];
    [partch43 addFraction:21 over:20];
    [partch43 addFraction:16 over:15];
    [partch43 addFraction:12 over:11];
    [partch43 addFraction:11 over:10];
    [partch43 addFraction:10 over:9];
    [partch43 addFraction:9 over:8];
    [partch43 addFraction:8 over:7];
    [partch43 addFraction:7 over:6];
    [partch43 addFraction:32 over:27];
    [partch43 addFraction:6 over:5];
    [partch43 addFraction:11 over:9];
    [partch43 addFraction:5 over:4];
    [partch43 addFraction:14 over:11];
    [partch43 addFraction:9 over:7];
    [partch43 addFraction:21 over:16];
    [partch43 addFraction:4 over:3];
    [partch43 addFraction:27 over:20];
    [partch43 addFraction:11 over:8];
    [partch43 addFraction:7 over:5];
    [partch43 addFraction:10 over:7];
    [partch43 addFraction:16 over:11];
    [partch43 addFraction:40 over:27];
    [partch43 addFraction:3 over:2];
    [partch43 addFraction:32 over:21];
    [partch43 addFraction:14 over:9];
    [partch43 addFraction:11 over:7];
    [partch43 addFraction:8 over:5];
    [partch43 addFraction:18 over:11];
    [partch43 addFraction:5 over:3];
    [partch43 addFraction:27 over:16];
    [partch43 addFraction:12 over:7];
    [partch43 addFraction:7 over:4];
    [partch43 addFraction:16 over:9];
    [partch43 addFraction:9 over:5];
    [partch43 addFraction:20 over:11];
    [partch43 addFraction:11 over:6];
    [partch43 addFraction:15 over:8];
    [partch43 addFraction:40 over:21];
    [partch43 addFraction:64 over:33];
    [partch43 addFraction:160 over:81];
    
    [self.scales addObject:partch43];
    
    Scale *catler24 = [[Scale alloc] initWithName:@"Catler 24"];
    [catler24 addFraction:1 over:1];
    [catler24 addFraction:33 over:32];
    [catler24 addFraction:16 over:15];
    [catler24 addFraction:9 over:8];
    [catler24 addFraction:8 over:7];
    [catler24 addFraction:7 over:6];
    [catler24 addFraction:6 over:5];
    [catler24 addFraction:128 over:105];
    [catler24 addFraction:16 over:13];
    [catler24 addFraction:5 over:4];
    [catler24 addFraction:21 over:16];
    [catler24 addFraction:4 over:3];
    [catler24 addFraction:11 over:8];
    [catler24 addFraction:45 over:32];
    [catler24 addFraction:16 over:11];
    [catler24 addFraction:3 over:2];
    [catler24 addFraction:8 over:5];
    [catler24 addFraction:13 over:8];
    [catler24 addFraction:5 over:3];
    [catler24 addFraction:27 over:16];
    [catler24 addFraction:7 over:4];
    [catler24 addFraction:16 over:9];
    [catler24 addFraction:24 over:13];
    [catler24 addFraction:15 over:8];
    
    [self.scales addObject:catler24];
    
    Scale *young12 = [[Scale alloc] initWithName:@"Young 12 (The Well-Tuned Piano)"];
    [young12 addFraction:1 over:1];
    [young12 addFraction:567 over:512];
    [young12 addFraction:9 over:8];
    [young12 addFraction:147 over:128];
    [young12 addFraction:21 over:16];
    [young12 addFraction:1323 over:1024];
    [young12 addFraction:189 over:128];
    [young12 addFraction:3 over:2];
    [young12 addFraction:49 over:32];
    [young12 addFraction:7 over:4];
    [young12 addFraction:441 over:256];
    [young12 addFraction:63 over:32];
    
    [self.scales addObject:young12];
    
    Scale *harrison16 = [[Scale alloc] initWithName:@"Harrison 16"];
    [harrison16 addFraction:1 over:1];
    [harrison16 addFraction:16 over:15];
    [harrison16 addFraction:10 over:9];
    [harrison16 addFraction:8 over:7];
    [harrison16 addFraction:7 over:6];
    [harrison16 addFraction:6 over:5];
    [harrison16 addFraction:5 over:4];
    [harrison16 addFraction:4 over:3];
    [harrison16 addFraction:17 over:12];
    [harrison16 addFraction:3 over:2];
    [harrison16 addFraction:8 over:5];
    [harrison16 addFraction:5 over:3];
    [harrison16 addFraction:12 over:7];
    [harrison16 addFraction:7 over:4];
    [harrison16 addFraction:9 over:5];
    [harrison16 addFraction:15 over:8];
    
    [self.scales addObject:harrison16];
    
    Scale *zarlino16 = [[Scale alloc] initWithName:@"Zarlino 16"];
    [zarlino16 addFraction:1 over:1];
    [zarlino16 addFraction:25 over:24];
    [zarlino16 addFraction:10 over:9];
    [zarlino16 addFraction:9 over:8];
    [zarlino16 addFraction:32 over:27];
    [zarlino16 addFraction:6 over:5];
    [zarlino16 addFraction:5 over:4];
    [zarlino16 addFraction:4 over:3];
    [zarlino16 addFraction:25 over:18];
    [zarlino16 addFraction:45 over:32];
    [zarlino16 addFraction:3 over:2];
    [zarlino16 addFraction:25 over:16];
    [zarlino16 addFraction:5 over:3];
    [zarlino16 addFraction:16 over:9];
    [zarlino16 addFraction:9 over:5];
    [zarlino16 addFraction:15 over:8];
    
    [self.scales addObject:zarlino16];
    
    for (int i=0; i < [self.scales count]; ++i) {
        [self.scaleMenu addItemWithTitle:[[self.scales objectAtIndex:i] name]];
    }
}

- (void) updateScale {
    NSMutableString *scaleString = [[NSMutableString alloc] init];
    NSString *scaleType = [self.scaleMenu.selectedItem title];
    
    Scale *scale;
    for (int i=0; i < [self.scales count]; ++i) {
        if ([scaleType isEqualToString:[[self.scales objectAtIndex:i] name]]) {
            scale = [self.scales objectAtIndex:i];
            break;
        }
    }
    
    BOOL flag;
    Note *baseNote = [[Note alloc] initWithString:[self.baseNoteField stringValue]];
    for (int i=0; i < [[scale fractions] count]; ++i) {
        Fraction *scaleTone = (Fraction *)[scale nthDegree:i];
        Note *noteAddend = [[Note alloc] initWithFraction:scaleTone withFlag:&flag];
        Note *note = [baseNote add:noteAddend];
        
        [scaleString appendFormat:@"%-*s%s\n", 12, [[note description] UTF8String], [[scaleTone description] UTF8String]];
    }

    [self.scaleField setString:scaleString];
}
@end
