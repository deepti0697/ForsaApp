        //
        //  VideoRecordingManager.m
        //  CustomVideoRecording
        //
        //  Created by 郭伟林 on 17/1/18.
        //  Copyright © 2017年 SR. All rights reserved.
        //

#import "videorecordingmanager.h"
#import "videorecordingwriter.h"
#import <Photos/Photos.h>

@interface videorecordingmanager () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, CAAnimationDelegate>
{
                // 视频分辨率宽
        NSInteger _resolutionWidth;
                // 视频分辨率高
        NSInteger _resolutionHeight;
        
                // 音频通道
        int _audioChannel;
                // 音频采样率
        Float64 _sampleRate;
        
        int videoframecount;
}


@property (nonatomic, strong) AVCaptureDeviceInput *backCameraInput;
@property (nonatomic, strong) AVCaptureDeviceInput *frontCameraInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;

@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureConnection *audioConnection;

@property (nonatomic, strong) videorecordingwriter *recordingWriter;

@property (nonatomic, assign) CMTime  startRecordingCMTime;

@property (nonatomic, assign) CGFloat currentrecordingtime;

@property (nonatomic, assign) BOOL isrecording;

@property (nonatomic, copy) NSString *cacheDirectoryPath;

@property (nonatomic, strong) NSURL *videoFileURL;

@end

@implementation videorecordingmanager

- (void)dealloc {
        
        [_capturesession stopRunning];
        
        _capturesession   = nil;
        _previewlayer     = nil;
        _backCameraInput  = nil;
        _frontCameraInput = nil;
        _audioOutput      = nil;
        _videoOutput      = nil;
        _audioConnection  = nil;
        _videoConnection  = nil;
        _recordingWriter  = nil;
        _captureQueue     = nil;
}

+ (void)load {
        
        NSString *cacheDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                                    stringByAppendingPathComponent:NSStringFromClass([self class])];
        BOOL isDirectory = NO;
        BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDirectory];
        if (!isExists || !isDirectory) {
                [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
}

#pragma mark - Lazy Load

- (NSString *)cacheDirectoryPath {
        
        if (!_cacheDirectoryPath) {
                _cacheDirectoryPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                                       stringByAppendingPathComponent:NSStringFromClass([self class])];
        }
        return _cacheDirectoryPath;
}

- (AVCaptureVideoPreviewLayer *)previewlayer {
        
        if (!_previewlayer) {
                _previewlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.capturesession];
//            CGRect screensize = [UIScreen mainScreen].bounds;
//            _previewlayer.bounds = screensize;
            // Comment due to video stretching 2019-10-21
           // _previewlayer.position =  CGPointMake(CGRectGetMidX(screensize), CGRectGetMidY(screensize));
            
           // _previewlayer.videoGravity = AVLayerVideoGravityResize;
            
                _previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        }
        return _previewlayer;
}

- (AVCaptureSession *)capturesession {
        
        if (!_capturesession) {
                _capturesession = [[AVCaptureSession alloc] init];
                
                if ([_capturesession canAddInput:self.backCameraInput]) {
                        [_capturesession addInput:self.backCameraInput];
                }
                if ([_capturesession canAddInput:self.audioInput]) {
                        [_capturesession addInput:self.audioInput];
                }
                
                if ([_capturesession canAddOutput:self.videoOutput]) {
                        [_capturesession addOutput:self.videoOutput];
                }
                if ([_capturesession canAddOutput:self.audioOutput]) {
                        [_capturesession addOutput:self.audioOutput];
                }
//                _resolutionWidth  = 360;
//                _resolutionHeight = 640;
            
            _resolutionWidth  = [UIScreen mainScreen].bounds.size.width;
            _resolutionHeight = [UIScreen mainScreen].bounds.size.height;
            
                [_capturesession setSessionPreset:AVCaptureSessionPresetPhoto];
                self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
                
        }
        return _capturesession;  
}


#pragma mark KVO and Notifications

- (void) addObservers
{
//    [self.session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:SessionRunningContext];
//    [self addObserver:self forKeyPath:@"videoDeviceInput.device.systemPressureState" options:NSKeyValueObservingOptionNew context:SystemPressureContext];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.videoDeviceInput.device];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:self.session];
    
    /*
     A session can only run when the app is full screen. It will be interrupted
     in a multi-app layout, introduced in iOS 9, see also the documentation of
     AVCaptureSessionInterruptionReason. Add observers to handle these session
     interruptions and show a preview is paused message. See the documentation
     of AVCaptureSessionWasInterruptedNotification for other interruption reasons.
    */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionWasInterrupted:) name:AVCaptureSessionWasInterruptedNotification object:self.capturesession];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInterruptionEnded:) name:AVCaptureSessionInterruptionEndedNotification object:self.capturesession];
}

- (void) removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    [self.session removeObserver:self forKeyPath:@"running" context:SessionRunningContext];
//    [self removeObserver:self forKeyPath:@"videoDeviceInput.device.systemPressureState" context:SystemPressureContext];
}

- (void) sessionWasInterrupted:(NSNotification*)notification
{
    /*
     In some scenarios we want to enable the user to resume the session running.
     For example, if music playback is initiated via control center while
     using AVCam, then the user can let AVCam resume
     the session running, which will stop music playback. Note that stopping
     music playback in control center will not automatically resume the session
     running. Also note that it is not always possible to resume, see -[resumeInterruptedSession:].
    */
   // BOOL showResumeButton = NO;

    AVCaptureSessionInterruptionReason reason = [notification.userInfo[AVCaptureSessionInterruptionReasonKey] integerValue];
    NSLog(@"Capture session was interrupted with reason %ld", (long)reason);

    if (reason == AVCaptureSessionInterruptionReasonAudioDeviceInUseByAnotherClient ||
        reason == AVCaptureSessionInterruptionReasonVideoDeviceInUseByAnotherClient) {
       // showResumeButton = YES;
        if ([self.delegate respondsToSelector:@selector(audio_video_interuption)])
        {
            [self.delegate audio_video_interuption];
            
        }
        NSLog(@"Session stopped running due to audio  device in use");
        
    }
    else if (reason == AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableWithMultipleForegroundApps) {
        // Fade-in a label to inform the user that the camera is unavailable.
        if ([self.delegate respondsToSelector:@selector(audio_video_interuption)])
               {
                   [self.delegate audio_video_interuption];
                   
               }
               NSLog(@"Session stopped running due to  video device in use");
       
    }
    else if (reason == AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableDueToSystemPressure) {
        NSLog(@"Session stopped running due to shutdown system pressure level.");
    }

    if ([self.delegate respondsToSelector:@selector(interuption_stop_recording)])
    {
        [self.delegate interuption_stop_recording];
        
    }
    
}




- (void) sessionInterruptionEnded:(NSNotification*)notification
{
    NSLog(@"Capture session interruption ended");
    
//    if (!self.resumeButton.hidden) {
//        [UIView animateWithDuration:0.25 animations:^{
//            self.resumeButton.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            self.resumeButton.hidden = YES;
//        }];
//    }
//    if (!self.cameraUnavailableLabel.hidden) {
//        [UIView animateWithDuration:0.25 animations:^{
//            self.cameraUnavailableLabel.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            self.cameraUnavailableLabel.hidden = YES;
//        }];
//    }
    
   // when capture session ended then start again capturesession
    dispatch_async(self.captureQueue, ^{
                [self.capturesession startRunning];

    });
    

    
}




- (AVCaptureDeviceInput *)backCameraInput {
        
        if (!_backCameraInput) {
                AVCaptureDevice *backCameraDevice = nil;
                backCameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
                if ( ! backCameraDevice ) {
                                // If the back dual camera is not available, default to the back wide angle camera.
                        backCameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
                }
                if (backCameraDevice != nil)
                    {
                        [self configureCamera:backCameraDevice withFrameRate:30];
                    }
                NSError *error = nil;
                _backCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:backCameraDevice error:&error];
                if (error) {
                        NSLog(@"初始化后置摄像头失败!");
                }
        }
        return _backCameraInput;
}

- (AVCaptureDeviceInput *)frontCameraInput {
        
        if (!_frontCameraInput) {
                AVCaptureDevice *frontCameraDevice = nil;
                
                frontCameraDevice =  [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
                if ( ! frontCameraDevice ) {
                                // If the back dual camera is not available, default to the back wide angle camera.
                        frontCameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
                }
                if (frontCameraDevice != nil)
                    {
                        [self configureCamera:frontCameraDevice withFrameRate:30];
                    }
                NSError *error = nil;
                _frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:frontCameraDevice error:&error];
                if (error) {
                        NSLog(@"初始化前置摄像头失败!");
                }
        }
        return _frontCameraInput;
}
-(AVCaptureDevice *)getcurrentcameradevice
{
        AVCaptureInput *currentCameraInput = [_capturesession.inputs objectAtIndex:0];
        AVCaptureDevice *newCamera = nil;
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
            {
                newCamera = self.frontCameraInput.device;
            }
        else
            {
                newCamera = self.backCameraInput.device;
            }
        return newCamera;
}
- (void)configureCamera:(AVCaptureDevice *)device withFrameRate:(int)desiredFrameRate
{
        AVCaptureDeviceFormat *desiredFormat = nil;
        for ( AVCaptureDeviceFormat *format in [device formats] ) {
                for ( AVFrameRateRange *range in format.videoSupportedFrameRateRanges ) {
                        if ( range.maxFrameRate >= desiredFrameRate && range.minFrameRate <= desiredFrameRate ) {
                                desiredFormat = format;
                                goto desiredFormatFound;
                        }
                }
        }
        
desiredFormatFound:
        if ( desiredFormat ) {
                if ( [device lockForConfiguration:NULL] == YES ) {
                        device.activeFormat = desiredFormat ;
                        device.activeVideoMinFrameDuration = CMTimeMake ( 1, desiredFrameRate );
                                // Get video dimensions
//                        if let formatDescription = curVideoDevice?.activeFormat.formatDescription {
//                                let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
//                                resolution = CGSize(width: CGFloat(dimensions.width), height: CGFloat(dimensions.height))
//                                if portraitOrientation {
//                                        resolution = CGSize(width: resolution.height, height: resolution.width)
//                                }
//                        }
                        device.activeVideoMaxFrameDuration = CMTimeMake ( 1, desiredFrameRate );
                        [device unlockForConfiguration];
                }
        }
}
- (AVCaptureDeviceInput *)audioInput {
        
        if (!_audioInput) {
                AVCaptureDevice *captureDeviceAudio = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
                NSError *error = nil;
                _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDeviceAudio error:&error];
                if (error) {
                        NSLog(@"初始化麦克风失败!");
                }
        }
        return _audioInput;
}

- (AVCaptureVideoDataOutput *)videoOutput {
        
        if (!_videoOutput) {
                _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
                [_videoOutput setSampleBufferDelegate:self queue:self.captureQueue];
                _videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:@(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange), kCVPixelBufferPixelFormatTypeKey, nil];
                _videoOutput.alwaysDiscardsLateVideoFrames = NO;
                
        }
        return _videoOutput;
}

- (AVCaptureAudioDataOutput *)audioOutput {
        
        if (!_audioOutput) {
                _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
                [_audioOutput setSampleBufferDelegate:self queue:self.captureQueue];
        }
        return _audioOutput;
}

- (dispatch_queue_t)captureQueue {
        
        if (!_captureQueue) {
                _captureQueue = dispatch_queue_create("com.willing.SRVideoRecorder", DISPATCH_QUEUE_SERIAL);
        }
        return _captureQueue;
}

- (AVCaptureConnection *)videoConnection {
        
                // Notice: Should not use lazy load, cos switch camera input device will have bug!
        _videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
        if (!_videoConnection) {
        }
        return _videoConnection;
}

- (AVCaptureConnection *)audioConnection {
        
        if (!_audioConnection) {
                _audioConnection = [self.audioOutput connectionWithMediaType:AVMediaTypeAudio];
        }
        return _audioConnection;
}

#pragma mark - Init

- (instancetype)init {
        
        if (self = [super init]) {
           
                _maxrecordingtime = 10.0;
                _autosavevideo = NO;
                _hashcounter = 8.0;
                _rotationangle = 0;
                  [self.capturesession startRunning];
        }
        return self;
}

#pragma mark - Public Methods

- (void)startcapture {
        
        _isrecording = NO;
        _startRecordingCMTime = CMTimeMake(0, 0);
        _currentrecordingtime = 0;
        
        [self.capturesession startRunning];
}

- (void)stopcapture {
        
        [self.capturesession stopRunning];
}

- (void)startrecoring {
        
        if (self.isrecording) {
                return;
        }
        videoframecount = 0;
        _isrecording = YES;
//    NSString *pathString = [ NSHomeDirectory()  stringByAppendingPathComponent:@"/Documents/capture.mp4"];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        initRecording([pathString UTF8String]) ;
//    });
}

- (void)stoprecoring {
        
        [self stoprecordinghandler:nil];
        
}

- (void)stoprecordinghandler:(void (^)(UIImage *firstFrameImage))handler {
        
        if (!_isrecording) {
                return;
        }
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                   stopRecording() ;
//               });
        _isrecording = NO;
        
                // may be it crash if video path is nil
        NSLog(@"_recordingWriter.videoPath = %@",_recordingWriter.videoPath);
        if (_recordingWriter.videoPath)
            {
                _videoFileURL = [NSURL fileURLWithPath:_recordingWriter.videoPath];
            }
        
     
        dispatch_async(self.captureQueue, ^{
                __weak typeof(self) weakSelf = self;
                [self->_recordingWriter finishWritingWithCompletionHandler:^{
                        weakSelf.isrecording = NO;
                        weakSelf.startRecordingCMTime = CMTimeMake(0, 0);
                        weakSelf.currentrecordingtime = 0;
                        weakSelf.recordingWriter = nil;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                                if ([weakSelf.delegate respondsToSelector:@selector(updaterecordingprogress:)]) {
                                        [weakSelf.delegate updaterecordingprogress:self.currentrecordingtime / self.maxrecordingtime];
                                }
                        });
                        
                        if (weakSelf.autosavevideo) {
                                [self savecurrentrecordingvideo];
                        }
                        
                        if (handler) {
                                NSURL *videoFileURL = [NSURL fileURLWithPath:weakSelf.videopath];
                                AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoFileURL options:nil];
                                AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:videoAsset];
                                imageGenerator.appliesPreferredTrackTransform = TRUE;
                                CMTime thumbTime = CMTimeMakeWithSeconds(0, 60);
                                imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
                                [imageGenerator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]]
                                                                     completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image,
                                                                                         CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
                                                                             if (result != AVAssetImageGeneratorSucceeded) {
                                                                                     dispatch_async(dispatch_get_main_queue(), ^{                                                                                 handler(nil);
                                                                                     });
                                                                                     return;
                                                                             }
                                                                             UIImage *firstFrameImage = [UIImage imageWithCGImage:image];
                                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                                     if (firstFrameImage) {
                                                                                             handler(firstFrameImage);
                                                                                     } else {
                                                                                             handler(nil);
                                                                                     }
                                                                             });
                                                                     }];
                        }
                }];
        });
}

#pragma mark - Public Methods

- (void)switchCameraAnimation {
        
        CATransition *filpAnimation = [CATransition animation];
        filpAnimation.delegate = self;
        filpAnimation.duration = 0.5;
        filpAnimation.type = @"oglFlip";
        filpAnimation.subtype = kCATransitionFromRight;
        filpAnimation.timingFunction = UIViewAnimationCurveEaseInOut;
        [self.previewlayer addAnimation:filpAnimation forKey:@"filpAnimation"];
}

- (void)animationDidStart:(CAAnimation *)anim {
        
        self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
        [self.capturesession startRunning];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
        [self.capturesession startRunning];
        
}
- (void)switchcamerainputdevicetofront {
        
        [self.capturesession stopRunning];
        [self.capturesession removeInput:self.backCameraInput];
        
        if ([self.capturesession canAddInput:self.frontCameraInput]) {
                [self.capturesession addInput:self.frontCameraInput];
                [_capturesession setSessionPreset:AVCaptureSessionPresetPhoto];

                [self switchCameraAnimation];
        }
}

- (void)swithcamerainputdevicetoback {
        
        [self.capturesession stopRunning];
        [self.capturesession removeInput:self.frontCameraInput];
        
        if ([self.capturesession canAddInput:self.backCameraInput]) {
                [self.capturesession addInput:self.backCameraInput];
                [_capturesession setSessionPreset:AVCaptureSessionPresetPhoto];

                [self switchCameraAnimation];
        }
}

- (void)openflashlight {
        
        AVCaptureDevice *backCameraDevice;
        backCameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        if ( ! backCameraDevice ) {
                        // If the back dual camera is not available, default to the back wide angle camera.
                backCameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        }
        
        if (backCameraDevice.torchMode == AVCaptureTorchModeOff) {
                [backCameraDevice lockForConfiguration:nil];
                
                backCameraDevice.torchMode = AVCaptureTorchModeOn;
                backCameraDevice.flashMode = AVCaptureFlashModeOn;
                
                [backCameraDevice unlockForConfiguration];
        }
}

- (void)closeflashlight {
        
        AVCaptureDevice *backCameraDevice;
        backCameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        if ( ! backCameraDevice ) {
                        // If the back dual camera is not available, default to the back wide angle camera.
                backCameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        }
        
        if (backCameraDevice.torchMode == AVCaptureTorchModeOn) {
                [backCameraDevice lockForConfiguration:nil];
                
                backCameraDevice.torchMode = AVCaptureTorchModeOff;
                backCameraDevice.flashMode = AVCaptureFlashModeOff;
                
                [backCameraDevice unlockForConfiguration];
        }
}

- (void)savecurrentrecordingvideo {
                //[self copyfiletodocumentdirectory];
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                        
                        [self saveCurrentRecordingVideoToPhotoLibrary];
                        
                }];
        } else {
                [self saveCurrentRecordingVideoToPhotoLibrary];
        }
}
-(void)copyfiletodocumentdirectory
{
        
        NSString *currentDateString = [self generateRandomString:80];
        NSString *videoName = [NSString stringWithFormat:@"video_%@.mp4",currentDateString];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *filepath = [documentsDirectory stringByAppendingPathComponent:videoName];
        if ([fileManager fileExistsAtPath:filepath] == YES) {
                [fileManager removeItemAtPath:filepath error:&error];
        }
        [fileManager copyItemAtPath:self.videoFileURL.path toPath:filepath error:&error];
        self.currentvideodocpath = filepath;
}
-(void)copyfiletodocumentdirectorywithhandler:(void (^)(NSString *metafilepath))handler
{
        
        NSString *currentDateString = [self generateRandomString:80];
        NSString *videoName = [NSString stringWithFormat:@"video_%@.mp4",currentDateString];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filepath = [documentsDirectory stringByAppendingPathComponent:videoName];
        if ([fileManager fileExistsAtPath:filepath] == YES) {
                [fileManager removeItemAtPath:filepath error:&error];
        }
        BOOL copyresult =  [fileManager copyItemAtPath:self.videoFileURL.path toPath:filepath error:&error];
        
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"subdirctories"];
   if ([savedValue isEqualToString:@"yes"])
   {
       NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                               stringForKey:@"foldername"];
       documentsDirectory = [NSString stringWithFormat:@"%@/%@",documentsDirectory,savedValue];
   }
        NSString *ffilepath = [documentsDirectory stringByAppendingPathComponent:videoName];
        if ([fileManager fileExistsAtPath:ffilepath] == YES) {
                [fileManager removeItemAtPath:ffilepath error:&error];
        }
         copyresult =  [fileManager copyItemAtPath:self.videoFileURL.path toPath:ffilepath error:&error];
        
        if (copyresult)
            {
                self.currentvideodocpath = filepath;
                handler(filepath);
            }
        else
            {
                handler(nil);
            }
}
-(void)changemetadataandwritetodocumentdirectory:(void (^)(NSString *metafilepath))handler
{
        NSMutableArray *metadata = [NSMutableArray array];
        AVMutableMetadataItem *mi = [AVMutableMetadataItem metadataItem];
        mi.key = AVMetadataCommonKeyTitle;
        mi.keySpace = AVMetadataKeySpaceCommon;
        mi.value = self.currentvideotitle;
        [metadata addObject:mi];
        
        AVMutableMetadataItem *mi1 = [AVMutableMetadataItem metadataItem];
        mi1.key = AVMetadataCommonKeyDescription ;
        mi1.keySpace = AVMetadataKeySpaceCommon;
        
        mi1.value = self.currentvideodata;
        [metadata addObject:mi1];
        
        AVMutableMetadataItem *mi2 = [AVMutableMetadataItem metadataItem];
        mi2.key = AVMetadataCommonKeyAlbumName ;
        mi2.keySpace = AVMetadataKeySpaceCommon;
        
        mi2.value = self.currentvideodata;
        [metadata addObject:mi2];
        
        
        AVMutableMetadataItem *mi3 = [AVMutableMetadataItem metadataItem];
        mi3.key = AVMetadataCommonKeyArtist ;
        mi3.keySpace = AVMetadataKeySpaceCommon;
        
        mi3.value = self.currentvideodata;
        [metadata addObject:mi3];
        
        AVMutableMetadataItem *mi4 = [AVMutableMetadataItem metadataItem];
        mi4.key = AVMetadataCommonKeyAuthor ;
        mi4.keySpace = AVMetadataKeySpaceCommon;
        
        mi4.value = self.currentvideodata;
        [metadata addObject:mi4];
        
        
        AVMutableMetadataItem *mi5 = [AVMutableMetadataItem metadataItem];
        mi5.key = AVMetadataCommonKeyCreator ;
        mi5.keySpace = AVMetadataKeySpaceCommon;
        
        mi5.value = self.currentvideodata;
        [metadata addObject:mi5];
        
                //    AVMutableMetadataItem *mi6 = [AVMutableMetadataItem metadataItem];
                //    mi6.key = AVMetadataCommonKeyTitle ;
                //    mi6.keySpace = AVMetadataKeySpaceCommon;
                //
                //    mi6.value = self.currentvideodata;
                //    [metadata addObject:mi6];
        
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:self.videoFileURL options:nil];
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
        NSString *currentDateString = [self generateRandomString:80];
        NSString *videoName = [NSString stringWithFormat:@"video_%@.mp4",currentDateString];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *filepath = [documentsDirectory stringByAppendingPathComponent:videoName];
        if ([fileManager fileExistsAtPath:filepath] == YES) {
                [fileManager removeItemAtPath:filepath error:&error];
        }
        
                //         self.currentvideodocpath = filepath;
        
        exportSession.outputURL = [NSURL fileURLWithPath:filepath];
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.metadata=metadata;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
             switch (exportSession.status) {
                     case AVAssetExportSessionStatusCompleted:
                             self.currentvideodocpath = filepath;
                             self->_videoFileURL = [NSURL fileURLWithPath:filepath];
                             handler(filepath);
                                     //                             NSLog(@"Export Complete %ld %@", (long)exportSession.status, exportSession.error);
                             break;
                     case AVAssetExportSessionStatusFailed:
                             NSLog(@"Failed:%@",exportSession.error);
                             handler(nil);
                             break;
                     case AVAssetExportSessionStatusCancelled:
                             NSLog(@"Canceled:%@",exportSession.error);
                             handler(nil);
                             break;
                     default:
                             handler(nil);
                             break;
             }
             
             
         }];
        
}
-(NSString*)generateRandomString:(int)num {
        NSMutableString* string = [NSMutableString stringWithCapacity:num];
        for (int i = 0; i < num; i++) {
                [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(26))];
        }
        return string;
}
- (void)saveCurrentRecordingVideoToPhotoLibrary {
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:self->_videoFileURL];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (!error) {
                        NSLog(@"Save video success!");
                        
                        if ([self.delegate respondsToSelector:@selector(updatewhenvideofilesavetocameraroll)]) {
                                [self.delegate updatewhenvideofilesavetocameraroll];
                        }
                } else {
                        NSLog(@"Save video failure!");
                        if ([self.delegate respondsToSelector:@selector(updatewhenvideofilesavetocamerarollfailed)]) {
                                [self.delegate updatewhenvideofilesavetocamerarollfailed];
                        }
                }
        }];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
        
        BOOL isVideo = YES;
        
        if (!_isrecording) {
                return;
        }
        
        if (captureOutput != self.videoOutput) {
                isVideo = NO;
        }
        
        if (!_recordingWriter) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"HH:mm:ss";
                NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]];
                NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
                NSString *videoName = [NSString stringWithFormat:@"video_%@.mp4", currentDateString];
                _videopath = [self.cacheDirectoryPath stringByAppendingPathComponent:videoName];
                        // may be it crash if video path is nil
                NSLog(@"_videopath = %@",_videopath);
                
                        // initialize recorder with video as well as audio
                if (!isVideo)
                    {
                        CMFormatDescriptionRef formatDescriptionRef = CMSampleBufferGetFormatDescription(sampleBuffer);
                        
                        const AudioStreamBasicDescription *audioStreamBasicDescription = CMAudioFormatDescriptionGetStreamBasicDescription(formatDescriptionRef);
                        _sampleRate = audioStreamBasicDescription -> mSampleRate;
                        _audioChannel = audioStreamBasicDescription -> mChannelsPerFrame;
                        
                        _recordingWriter = [videorecordingwriter recordingWriterWithVideoPath:_videopath resolutionWidth:_resolutionWidth resolutionHeight:_resolutionHeight audioChannel:_audioChannel sampleRate:_sampleRate rotationangle:_rotationangle];
                        

                        
                                //                    [_recordingWriter addmetadatawith:self.currentvideotitle withdecData:self.currentvideodata];
                    }
                        // initialize with video only if no audio available
                        //            else if (isVideo)
                        //                {
                        //                    _recordingWriter = [videorecordingwriter recordingWriterWithVideoPath:_videopath resolutionWidth:_resolutionWidth resolutionHeight:_resolutionHeight];
                        ////                     [_recordingWriter addmetadatawith:self.currentvideotitle withdecData:self.currentvideodata];
                        //                }
                
                
        }
        else if (!_recordingWriter.assetAudioInput && !isVideo)
            {
                        // add audio if not added previously
                CMFormatDescriptionRef formatDescriptionRef = CMSampleBufferGetFormatDescription(sampleBuffer);
                
                const AudioStreamBasicDescription *audioStreamBasicDescription = CMAudioFormatDescriptionGetStreamBasicDescription(formatDescriptionRef);
                _sampleRate = audioStreamBasicDescription -> mSampleRate;
                _audioChannel = audioStreamBasicDescription -> mChannelsPerFrame;
                [_recordingWriter addaudioinputwithaudioChannel:_audioChannel sampleRate:_sampleRate];
            }
        
        CMTime presentationTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        if (_startRecordingCMTime.value == 0) {
                _startRecordingCMTime = presentationTimeStamp;
        }
        
        CMTime subtract = CMTimeSubtract(presentationTimeStamp, _startRecordingCMTime);
        _currentrecordingtime = CMTimeGetSeconds(subtract);
        if (_currentrecordingtime > _maxrecordingtime) {
                if (_currentrecordingtime - _maxrecordingtime >= 0.1) {
                    if ([self.delegate respondsToSelector:@selector(recordingmanagerreachedmaxrecordtime:)]) {
                        [self.delegate recordingmanagerreachedmaxrecordtime:_maxrecordingtime];
                        
                    }
                    
                        return;
                }
        }
        
        [_recordingWriter writeWithSampleBuffer:sampleBuffer isVideo:isVideo];
        
        if (isVideo)
            {
                videoframecount += 1;
//                if (videoframecount % _hashcounter == 0 || videoframecount == 1)
//                    {
                        CFRetain(sampleBuffer);
                        
                        NSData* cgImage = [self dataFromSampleBuffer:sampleBuffer];
                        
                        if ([self.delegate respondsToSelector:@selector(updatesamplebuffer:)]) {
                                [self.delegate updatesamplebuffer:videoframecount];
                        }
                        if ([self.delegate respondsToSelector:@selector(updaterecordingvideoframedata:)]) {
                                [self.delegate updaterecordingvideoframedata:cgImage];
                                
                        }
                        
                        
                        CFRelease(sampleBuffer);
//                    }
            }
        dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(updaterecordingprogress:)]) {
                        [self.delegate updaterecordingprogress:self->_currentrecordingtime / self->_maxrecordingtime];
                }
                if ([self.delegate respondsToSelector:@selector(updaterecordingtime:)]) {
                        [self.delegate updaterecordingtime:subtract];
                }
            
           
            
                
        });
}
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CVPixelBufferLockBaseAddress(imageBuffer, 0);
        void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        CGImageRef quartzImage = CGBitmapContextCreateImage(context);
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        UIImage *image = [UIImage imageWithCGImage:quartzImage];
        CGImageRelease(quartzImage);
        return (image);
}
- (NSData*) dataFromSampleBuffer:(CMSampleBufferRef) sampleBuffer // Create a CGImageRef from sample buffer data
{
        CVImageBufferRef videoImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CVPixelBufferLockBaseAddress(videoImageBuffer,0);
        
        
        void *baseAddress = NULL;
        NSUInteger totalBytes = 0;
        size_t height = 0;
        OSType pixelFormat = CVPixelBufferGetPixelFormatType(videoImageBuffer);
        if (pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange ||
            pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
                size_t planeCount = CVPixelBufferGetPlaneCount(videoImageBuffer);
                baseAddress = CVPixelBufferGetBaseAddressOfPlane(videoImageBuffer, 0);
                
                for (int plane = 0; plane < planeCount; plane++) {
                        size_t planeHeight = CVPixelBufferGetHeightOfPlane(videoImageBuffer, plane);
                        size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(videoImageBuffer, plane);
                        height += planeHeight;
                        totalBytes += (int)planeHeight * (int)bytesPerRow;
                }
        } else  {
                baseAddress = CVPixelBufferGetBaseAddress(videoImageBuffer);
                height = CVPixelBufferGetHeight(videoImageBuffer);
                size_t bytesPerRow = CVPixelBufferGetBytesPerRow(videoImageBuffer);
                totalBytes += (int)height * (int)bytesPerRow;
        }
                // Doesn't have to be an NSData object
        NSData *rawPixelData = [NSData dataWithBytes:baseAddress length:totalBytes];
        
        CVPixelBufferUnlockBaseAddress(videoImageBuffer,0);
        
        return rawPixelData;
}
@end

