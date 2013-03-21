//
//  ToneGenerator.h
//  NoteGrind
//
//  Created by Benjamin Selfridge on 3/16/13.
//  Copyright (c) 2013 Benjamin Selfridge. All rights reserved.
//

#ifndef __TONE_GENERATOR_H
#define __TONE_GENERATOR_H

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

//const int NUM_OVERTONES = 11;

@interface TonePlayer : NSObject

{
	AudioComponentInstance toneUnit;
    
@public
	double frequency1;
    double frequency2;
    
    BOOL channel1_on;
    BOOL channel2_on;
    
	double sampleRate;
	double theta1;
    double theta2;
    
    double overtones[11];
}
- (BOOL)togglePlay: (BOOL)on;
- (void)stop;

@end

#endif
