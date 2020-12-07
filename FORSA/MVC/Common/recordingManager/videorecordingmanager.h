//
//  VideoRecordingManager.h
//  CustomVideoRecording
//
//  Created by 郭伟林 on 17/1/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol videorecordingmanagerdelegate <NSObject>
- (void)updaterecordingtime:(CMTime)recordduration;
- (void)updaterecordingprogress:(CGFloat)progress;
- (void)updaterecordingvideoframedata:(NSData *)framedata;
- (void)updaterecordingvideoframeimage:(UIImage *)capturedimage;
- (void)updatesamplebuffer:(int)framecount;
- (void)updatewhenvideofilesavetocameraroll;
- (void)updatewhenvideofilesavetocamerarollfailed;
- (void)recordingmanagerreachedmaxrecordtime:(CGFloat)maxrecordingtime;
- (void)interuption_stop_recording;
-(void)audio_video_interuption;

@end

@interface videorecordingmanager : NSObject

@property (nonatomic, weak) id<videorecordingmanagerdelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isrecording;

@property (nonatomic, assign) CGFloat maxrecordingtime;
@property (nonatomic, assign, readonly) CGFloat currentrecordingtime;

@property (nonatomic, strong) NSString *videopath;

@property (nonatomic, assign) BOOL autosavevideo;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewlayer;
@property (nonatomic, strong) AVCaptureSession *capturesession;
@property (nonatomic, assign) int hashcounter;
@property (nonatomic, strong) NSString *currentvideodocpath;
@property (nonatomic, strong) NSString *currentvideotitle;
@property (nonatomic, strong) NSString *currentvideodata;
@property (nonatomic, assign) CGFloat rotationangle;
@property (nonatomic, strong) dispatch_queue_t captureQueue;


- (void)startcapture;
- (void)stopcapture;
- (void)addObservers;
- (void)removeObservers;
- (void)startrecoring;
- (void)stoprecoring;
- (void)stoprecordinghandler:(void (^)(UIImage *movieImage))handler;

- (void)openflashlight;
- (void)closeflashlight;

- (void)switchcamerainputdevicetofront;
- (void)swithcamerainputdevicetoback;

- (void)savecurrentrecordingvideo;
-(void)copyfiletodocumentdirectory;
-(void)changemetadataandwritetodocumentdirectory:(void (^)(NSString *metafilepath))handler;
-(void)copyfiletodocumentdirectorywithhandler:(void (^)(NSString *metafilepath))handler;
@end
