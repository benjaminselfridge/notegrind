//
//  ToneGenerator.m
//  NoteGrind
//
//  Created by Benjamin Selfridge on 3/16/13.
//  Copyright (c) 2013 Benjamin Selfridge. All rights reserved.
//

#import "TonePlayer.h"
#import <AudioToolbox/AudioToolbox.h>

OSStatus RenderTone(void *tg_void,
                    AudioUnitRenderActionFlags 	*ioActionFlags,
                    const AudioTimeStamp 		*inTimeStamp,
                    UInt32 						inBusNumber,
                    UInt32 						inNumberFrames,
                    AudioBufferList 			*ioData)

{
    TonePlayer *tg = (__bridge TonePlayer *) tg_void;
    
	// Fixed amplitude is good enough for our purposes
	const double amplitude = 0.25;
    
	// Get the tone parameters out of the view controller
	double theta1 = tg->theta1;
    double theta2 = tg->theta2;
	double theta_increment1 = 2.0 * M_PI * tg->frequency1 / tg->sampleRate;
	double theta_increment2 = 2.0 * M_PI * tg->frequency2 / tg->sampleRate;
    
	// This is a mono tone generator so we only need the first buffer
	const int channel1 = 0;
    const int channel2 = 1;
	Float32 *buffer1 = (Float32 *)ioData->mBuffers[channel1].mData;
	Float32 *buffer2 = (Float32 *)ioData->mBuffers[channel2].mData;
	
	// Generate the samples
	for (UInt32 frame = 0; frame < inNumberFrames; frame++) 
	{
        if (tg->channel1_on) {
            buffer1[frame] = sin(theta1) * amplitude;
            for (int i=1; i < 11; ++i) {
                buffer1[frame] += sin(theta1*(i+1)) * amplitude * tg->overtones[i];
            }
        }
        else {
            buffer1[frame] = 0.0;
        }
        if (tg->channel2_on) {
            buffer2[frame] = sin(theta2) * amplitude;
            for (int i=1; i < 11; ++i) {
                buffer2[frame] += sin(theta2*(i+1)) * amplitude * tg->overtones[i];
            }
        }
        else {
            buffer2[frame] = 0.0;
        }
		
		theta1 += theta_increment1;
		theta2 += theta_increment2;
		if (theta1 > 2.0 * M_PI)
		{
			theta1 -= 2.0 * M_PI;
		}
		if (theta2 > 2.0 * M_PI)
		{
			theta2 -= 2.0 * M_PI;
		}
	}
	
	// Store the theta back in the view controller
	tg->theta1 = theta1;
    tg->theta2 = theta2;
    
	return noErr;
}

void ToneInterruptionListener(void *tg_void, UInt32 inInterruptionState)
{
    TonePlayer *tg = (__bridge TonePlayer *) tg_void;
	[tg stop];
}

@implementation TonePlayer

- (id) init {
	sampleRate = 44100;
    channel1_on = NO;
    channel2_on = NO;
    frequency1 = 440.0;
    frequency2 = 528.0;
    
    self->overtones[0] = 1.0;
    for (int i=1; i < 11; ++i) {
        self->overtones[i] = 0.0;
    }
    
    return self;
}

- (void)createToneUnit
{
	// Configure the search parameters to find the default playback output unit
	// (called the kAudioUnitSubType_RemoteIO on iOS but
	// kAudioUnitSubType_DefaultOutput on Mac OS X)
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_DefaultOutput;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	// Get the default playback output unit
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	NSAssert(defaultOutput, @"Can't find default output");
	
	// Create a new unit based on this that we'll use for output
	OSErr err = AudioComponentInstanceNew(defaultOutput, &toneUnit);
	NSAssert1(toneUnit, @"Error creating unit: %d", err);
	
	// Set our tone rendering function on the unit
	AURenderCallbackStruct input;
	input.inputProc = RenderTone;
	input.inputProcRefCon = (__bridge void *)(self);
	err = AudioUnitSetProperty(toneUnit,
                               kAudioUnitProperty_SetRenderCallback,
                               kAudioUnitScope_Input,
                               0,
                               &input,
                               sizeof(input));
	NSAssert1(err == noErr, @"Error setting callback: %d", err);
	
	// Set the format to 32 bit, single channel, floating point, linear PCM
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat;
	streamFormat.mSampleRate = sampleRate;
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags =
    kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;
	streamFormat.mBytesPerFrame = four_bytes_per_float;
	streamFormat.mChannelsPerFrame = 2;
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	err = AudioUnitSetProperty (toneUnit,
                                kAudioUnitProperty_StreamFormat,
                                kAudioUnitScope_Input,
                                0,
                                &streamFormat,
                                sizeof(AudioStreamBasicDescription));
	NSAssert1(err == noErr, @"Error setting stream format: %d", err);
}

- (BOOL)togglePlay: (BOOL) on
{
    if (on && toneUnit) return YES;
    if (!on && !toneUnit) return NO;
    
	if (!on)
	{
		AudioOutputUnitStop(toneUnit);
		AudioUnitUninitialize(toneUnit);
		AudioComponentInstanceDispose(toneUnit);
		toneUnit = nil;
        
        return NO;
	}
	else
	{
		[self createToneUnit];
		
		// Stop changing parameters on the unit
		OSErr err = AudioUnitInitialize(toneUnit);
		NSAssert1(err == noErr, @"Error initializing unit: %d", err);
		
		// Start playback
		err = AudioOutputUnitStart(toneUnit);
		NSAssert1(err == noErr, @"Error starting unit: %d", err);
        
        return YES;
	}
}

- (void)stop
{
	if (toneUnit)
	{
		[self togglePlay:NO];
	}
}

@end
