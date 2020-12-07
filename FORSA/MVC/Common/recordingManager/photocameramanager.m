        //
        //  photocameramanager.m
        //  viaios
        //
        //  Created by AppleDev Seventeen A on 11/16/18.
        //  Copyright © 2018 Matraex. All rights reserved.
        //

#import "photocameramanager.h"
#import <Photos/Photos.h>
#import <CoreImage/CoreImage.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface photocameramanager () <AVCapturePhotoCaptureDelegate, CAAnimationDelegate>

@property (nonatomic, strong) AVCaptureDeviceInput *backCameraInput;
@property (nonatomic, strong) AVCaptureDeviceInput *frontCameraInput;

@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;




@property (nonatomic, copy) NSString *cacheDirectoryPath;

@property (nonatomic, strong) NSURL *videoFileURL;

@end
@implementation photocameramanager
- (void)dealloc {
        
        [_capturesession stopRunning];
        
        _capturesession   = nil;
        _previewlayer     = nil;
        _backCameraInput  = nil;
        _frontCameraInput = nil;
        _photoOutput      = nil;
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
            CGRect screensize = [UIScreen mainScreen].bounds;
            _previewlayer.bounds = screensize;
            
            // Comment due to stretch issue
            //_previewlayer.position =  CGPointMake(CGRectGetMidX(screensize), CGRectGetMidY(screensize));
          //  _previewlayer.videoGravity = AVLayerVideoGravityResize;
            
                _previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                _previewlayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        }
        return _previewlayer;
}

- (AVCaptureSession *)capturesession {
        
        if (!_capturesession) {
                _capturesession = [[AVCaptureSession alloc] init];
                
                if ([_capturesession canAddInput:self.backCameraInput]) {
                        [_capturesession addInput:self.backCameraInput];
                }
                
                
                if ([_capturesession canAddOutput:self.photoOutput]) {
                        [_capturesession addOutput:self.photoOutput];
                }
                
                [_capturesession setSessionPreset:AVCaptureSessionPresetPhoto];

                
                
                
        }
        return _capturesession;
}

- (AVCaptureDeviceInput *)backCameraInput {
        
        if (!_backCameraInput) {
                AVCaptureDevice *backCameraDevice = nil;
                backCameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
                if ( ! backCameraDevice ) {
                                // If the back dual camera is not available, default to the back wide angle camera.
                        backCameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
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
            
         

            NSArray *captureDeviceType = @[AVCaptureDeviceTypeBuiltInWideAngleCamera];
            AVCaptureDeviceDiscoverySession *captureDevice =
                          [AVCaptureDeviceDiscoverySession
                            discoverySessionWithDeviceTypes:captureDeviceType
                            mediaType:AVMediaTypeVideo
                            position:AVCaptureDevicePositionUnspecified];
//            int loopcounter = 0;

            for (int loopcounter = 0; loopcounter < captureDevice.devices.count ; loopcounter++) {
                NSLog(@"localizedName = %@ and position = %ld",[captureDevice.devices[loopcounter] localizedName],(long)[captureDevice.devices[loopcounter] position]);
            }

            
                AVCaptureDevice *frontCameraDevice = nil;
                
                frontCameraDevice =  [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
                
                
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

- (AVCapturePhotoOutput *)photoOutput {
        
        if (!_photoOutput) {
                _photoOutput = [[AVCapturePhotoOutput alloc] init];
                
        }
        return _photoOutput;
}


- (dispatch_queue_t)captureQueue {
        
        if (!_captureQueue) {
                _captureQueue = dispatch_queue_create("com.willing.photorecorder", DISPATCH_QUEUE_SERIAL);
        }
        return _captureQueue;
}



#pragma mark - Init

- (instancetype)init {
        
        if (self = [super init]) {
                _autosavevideo = NO;
            
        }
        return self;
}

#pragma mark - Public Methods

- (void)startcapture {
        
        [self.capturesession startRunning];
}

- (void)stopcapture {
        
        [self.capturesession stopRunning];
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
        
        [self.capturesession startRunning];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
        [self.capturesession startRunning];
        
}
- (void)switchcamerainputdevicetofront {
        _isfrontcam = TRUE;
        [self.capturesession stopRunning];
        [self.capturesession removeInput:self.backCameraInput];
        
        if ([self.capturesession canAddInput:self.frontCameraInput]) {
                [self.capturesession addInput:self.frontCameraInput];
                [_capturesession setSessionPreset:AVCaptureSessionPresetPhoto];

                [self switchCameraAnimation];
        }
}

- (void)swithcamerainputdevicetoback {
        _isfrontcam = FALSE;
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
- (void)captureimage {
        
        AVCapturePhotoSettings* avSettings = [AVCapturePhotoSettings photoSettings];
                //        [avSettings setAutoStillImageStabilizationEnabled:TRUE];
                //        [avSettings setFlashMode:AVCaptureFlashModeAuto];
                //        [avSettings setHighResolutionPhotoEnabled:TRUE];
        
        [self.photoOutput capturePhotoWithSettings:avSettings delegate:self];
        
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
                //  [self changemetadataandwritetodocumentdirectory];
        
                //        NSString *currentDateString = [self generateRandomString:80];
                //        NSString *videoName = [NSString stringWithFormat:@"video_%@.mp4",currentDateString];
                //
                //        NSFileManager *fileManager = [NSFileManager defaultManager];
                //        NSError *error;
                //        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                //        NSString *documentsDirectory = [paths objectAtIndex:0];
                //
                //        NSString *filepath = [documentsDirectory stringByAppendingPathComponent:videoName];
                //        if ([fileManager fileExistsAtPath:filepath] == YES) {
                //                [fileManager removeItemAtPath:filepath error:&error];
                //        }
                //        [fileManager copyItemAtPath:self.videoFileURL.path toPath:filepath error:&error];
                //        self.currentvideodocpath = filepath;
}
-(void)changemetadataandwritetodocumentdirectory:(void (^)(NSString *metafilepath))handler
{
        NSMutableArray *metadata = [NSMutableArray array];
        AVMutableMetadataItem *mi = [AVMutableMetadataItem metadataItem];
        mi.key = AVMetadataCommonKeyTitle;
        mi.keySpace = AVMetadataKeySpaceCommon;
        mi.value = self.currentphototitle;
        [metadata addObject:mi];
        
        AVMutableMetadataItem *mi1 = [AVMutableMetadataItem metadataItem];
        mi1.key = AVMetadataCommonKeyDescription ;
        mi1.keySpace = AVMetadataKeySpaceCommon;
        
        mi1.value = self.currentphotodata;
        [metadata addObject:mi1];
        
        AVMutableMetadataItem *mi2 = [AVMutableMetadataItem metadataItem];
        mi2.key = AVMetadataCommonKeyAlbumName ;
        mi2.keySpace = AVMetadataKeySpaceCommon;
        
        mi2.value = self.currentphotodata;
        [metadata addObject:mi2];
        
        
        AVMutableMetadataItem *mi3 = [AVMutableMetadataItem metadataItem];
        mi3.key = AVMetadataCommonKeyArtist ;
        mi3.keySpace = AVMetadataKeySpaceCommon;
        
        mi3.value = self.currentphotodata;
        [metadata addObject:mi3];
        
        AVMutableMetadataItem *mi4 = [AVMutableMetadataItem metadataItem];
        mi4.key = AVMetadataCommonKeyAuthor ;
        mi4.keySpace = AVMetadataKeySpaceCommon;
        
        mi4.value = self.currentphotodata;
        [metadata addObject:mi4];
        
        
        AVMutableMetadataItem *mi5 = [AVMutableMetadataItem metadataItem];
        mi5.key = AVMetadataCommonKeyCreator ;
        mi5.keySpace = AVMetadataKeySpaceCommon;
        
        mi5.value = self.currentphotodata;
        [metadata addObject:mi5];
        
        AVMutableMetadataItem *mi6 = [AVMutableMetadataItem metadataItem];
        mi6.key = AVMetadataCommonKeyTitle ;
        mi6.keySpace = AVMetadataKeySpaceCommon;
        
        mi6.value = self.currentphotodata;
        [metadata addObject:mi6];
        
        
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
                             self.currentphotodocpath = filepath;
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
                        NSLog(@"Save photo success!");
                        
                        if ([self.delegate respondsToSelector:@selector(updatewhenimagefilesavetocameraroll)]) {
                                [self.delegate updatewhenimagefilesavetocameraroll];
                        }
                } else {
                        NSLog(@"Save video failure!");
                        if ([self.delegate respondsToSelector:@selector(updatewhenimagefilesavetocamerarollfailed)]) {
                                [self.delegate updatewhenimagefilesavetocamerarollfailed];
                        }
                }
        }];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
-(void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error
{
        if (error) {
                NSLog(@"error : %@", error.localizedDescription);
        }
        if (photo.fileDataRepresentation) {
                NSData *data = photo.fileDataRepresentation;
                        //                NSData *datawithmeta = [self changemetadataofimage:data];
                        //
                        //                NSDictionary *props = [self getImageProperties:datawithmeta];
                        //                NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:props];
                        //                NSLog(@"photo metadata changed: %@", mutableDictionary);
//                if ([self.delegate respondsToSelector:@selector(updatecurrenttakenimagedata:)]) {
//                        [self.delegate updatecurrenttakenimagedata:data];
//                }
            if ([self.delegate respondsToSelector:@selector(updatecurrenttakenimagedata:)]) {
                    [self.delegate updatecurrenttakenimagedata:data];
            }
        }
}
-(NSData *)changemetadataofimage:(NSData *)imageData {
        NSDictionary *props = [self getImageProperties:imageData];
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:props];
        NSLog(@"photo metadata unchanged: %@", mutableDictionary);
        NSMutableDictionary *exifDictionary = props[(__bridge NSString *) kCGImagePropertyExifDictionary];
        NSString *usercomments = [NSString stringWithFormat:@"%@|%@", self.currentphototitle, self.currentphotodata];
        
        [exifDictionary setValue:usercomments
                          forKey:(NSString*)kCGImagePropertyExifUserComment];
        [mutableDictionary setObject:exifDictionary forKey:(NSString *)kCGImagePropertyExifDictionary];
        
        
        CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef) imageData);
        CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
        
                //                // the updated properties from above
                //        NSMutableDictionary *mutableDictionary;
        
                // create the new output data
        CFMutableDataRef newImageData = CFDataCreateMutable(NULL, 0);
                // my code assumes JPEG type since the input is from the iOS device camera
        CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef) @"image/jpg", kUTTypeImage);
                // create the destination
        CGImageDestinationRef destination = CGImageDestinationCreateWithData(newImageData, type, 1, NULL);
                // add the image to the destination
        CGImageDestinationAddImage(destination, imageRef, (__bridge CFDictionaryRef) mutableDictionary);
                // finalize the write
        CGImageDestinationFinalize(destination);
        
                // memory cleanup
        CGDataProviderRelease(imgDataProvider);
        CGImageRelease(imageRef);
        CFRelease(type);
        CFRelease(destination);
        
                // your new image data
        NSData *newImage = (__bridge_transfer NSData *)newImageData;
        
        return newImage;
}
- (NSDictionary *)getImageProperties:(NSData *)imageData {
                // get the original image metadata
        CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef) imageData, NULL);
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        NSDictionary *props = (__bridge_transfer NSDictionary *) properties;
        CFRelease(imageSourceRef);
        
        return props;
}
- (UIImage *)fixOrientationOfImage:(UIImage *)image {
        
                // No-op if the orientation is already correct
        if (image.imageOrientation == UIImageOrientationUp) return image;
        
                // We need to calculate the proper transformation to make the image upright.
                // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        switch (image.imageOrientation) {
                case UIImageOrientationDown:
                case UIImageOrientationDownMirrored:
                        transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
                        transform = CGAffineTransformRotate(transform, M_PI);
                        break;
                        
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                        transform = CGAffineTransformTranslate(transform, image.size.width, 0);
                        transform = CGAffineTransformRotate(transform, M_PI_2);
                        break;
                        
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                        transform = CGAffineTransformTranslate(transform, 0, image.size.height);
                        transform = CGAffineTransformRotate(transform, -M_PI_2);
                        break;
                case UIImageOrientationUp:
                case UIImageOrientationUpMirrored:
                        break;
        }
        
        switch (image.imageOrientation) {
                case UIImageOrientationUpMirrored:
                case UIImageOrientationDownMirrored:
                        transform = CGAffineTransformTranslate(transform, image.size.width, 0);
                        transform = CGAffineTransformScale(transform, -1, 1);
                        break;
                        
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRightMirrored:
                        transform = CGAffineTransformTranslate(transform, image.size.height, 0);
                        transform = CGAffineTransformScale(transform, -1, 1);
                        break;
                case UIImageOrientationUp:
                case UIImageOrientationDown:
                case UIImageOrientationLeft:
                case UIImageOrientationRight:
                        break;
        }
        
                // Now we draw the underlying CGImage into a new context, applying the transform
                // calculated above.
        CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                                 CGImageGetBitsPerComponent(image.CGImage), 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));
        CGContextConcatCTM(ctx, transform);
        switch (image.imageOrientation) {
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                                // Grr...
                        CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
                        break;
                        
                default:
                        CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
                        break;
        }
        
                // And now we just create a new UIImage from the drawing context
        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
        UIImage *img = [UIImage imageWithCGImage:cgimg];
        CGContextRelease(ctx);
        CGImageRelease(cgimg);
        return img;
}
@end

