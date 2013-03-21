//
//  AppDelegate.h
//  NoteGrind
//
//  Created by Benjamin Selfridge on 3/12/13.
//  Copyright (c) 2013 Benjamin Selfridge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Scale.h"
#import "TonePlayer.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSTextField *baseNoteField;
@property (strong) IBOutlet NSTextField *targetNoteField;
@property (strong) IBOutlet NSTextField *fractionField;
@property (strong) IBOutlet NSTextField *warningLabel;
@property (strong) IBOutlet NSPopUpButton *scaleMenu;
@property (strong) IBOutlet NSTextView *scaleField;
@property (strong) IBOutlet NSPanel *scalePanel;
@property (strong) IBOutlet NSButton *togglePlayButton;
@property (strong) IBOutlet NSButton *baseSoundCheck;
@property (strong) IBOutlet NSButton *targetSoundCheck;
@property (strong) IBOutlet NSPanel *timbrePanel;
@property (strong) IBOutlet NSTextField *centsLabel;
@property (strong) IBOutlet NSButton *toggleScaleButton;

@property (strong) IBOutlet NSSlider *secondHarmonicSlider;
@property (strong) IBOutlet NSSlider *thirdHarmonicSlider;
@property (strong) IBOutlet NSSlider *fourthHarmonicSlider;
@property (strong) IBOutlet NSSlider *fifthHarmonicSlider;
@property (strong) IBOutlet NSSlider *sixthHarmonicSlider;
@property (strong) IBOutlet NSSlider *seventhHarmonicSlider;
@property (strong) IBOutlet NSSlider *eighthHarmonicSlider;
@property (strong) IBOutlet NSSlider *ninthHarmonicSlider;
@property (strong) IBOutlet NSSlider *tenthHarmonicSlider;
@property (strong) IBOutlet NSSlider *eleventhHarmonicSlider;

@property NSMutableArray *scales;
@property TonePlayer *tg;

- (IBAction)setBaseNote:(id)sender;
- (IBAction)setTargetNote:(id)sender;
- (IBAction)setFraction:(id)sender;
- (IBAction)setScale:(id)sender;
- (IBAction)togglePlay:(id)sender;
- (IBAction)toggleBaseSound:(id)sender;
- (IBAction)toggleTargetSound:(id)sender;
- (IBAction)setOvertone:(id)sender;
- (IBAction)zeroOvertones:(id)sender;
- (IBAction)randomizeOvertones:(id)sender;
- (IBAction)toggleScale:(id)sender;
- (IBAction)showScales:(id)sender;

- (void) loadScales;
- (void) updateScale;
- (void) updateFrequencies;
- (void) updateOvertones;

@end
