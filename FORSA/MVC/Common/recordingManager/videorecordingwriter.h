//
//  VideoRecordingWriter.h
//  CustomVideoRecording
//
//  Created by 郭伟林 on 17/1/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface videorecordingwriter : NSObject

@property (nonatomic, copy, readonly) NSString *videoPath;
@property (nonatomic, strong) AVAssetWriterInput *assetAudioInput;

+ (instancetype)recordingWriterWithVideoPath:(NSString*)videoPath
                             resolutionWidth:(NSInteger)width
                            resolutionHeight:(NSInteger)height
                                audioChannel:(int)channel
                                  sampleRate:(Float64)rate
                               rotationangle:(CGFloat)angle;

// for video only, no audio

+ (instancetype)recordingWriterWithVideoPath:(NSString*)videoPath
                             resolutionWidth:(NSInteger)width
                            resolutionHeight:(NSInteger)height;

- (BOOL)writeWithSampleBuffer:(CMSampleBufferRef)sampleBuffer isVideo:(BOOL)isVideo;

- (void)finishWritingWithCompletionHandler:(void (^)(void))completion;
-(void)addmetadatawith:(NSString *)videotitle withdecData:(NSString *)dicdata;
-(void)addaudioinputwithaudioChannel:(int)channel
                          sampleRate:(Float64)rate;
@end
