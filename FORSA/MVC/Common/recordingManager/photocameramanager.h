//
//  photocameramanager.h
//  viaios
//
//  Created by AppleDev Seventeen A on 11/16/18.
//  Copyright © 2018 Matraex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN
@protocol photocameramanagerdelegate <NSObject>
- (void)updatewhenimagefilesavetocameraroll;
- (void)updatewhenimagefilesavetocamerarollfailed;
- (void)updatecurrentimagetaken:(UIImage *)capturedimage;
- (void)updatecurrenttakenimagedata:(NSData *)capturedimagedata;


@end
@interface photocameramanager : NSObject
@property (nonatomic, weak) id<photocameramanagerdelegate> delegate;
@property (nonatomic, assign) BOOL autosavevideo;

@property (nonatomic, strong) NSString *videopath;


@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewlayer;
@property (nonatomic, strong) AVCaptureSession *capturesession;
@property (nonatomic, strong) NSString *currentphotodocpath;
@property (nonatomic, strong) NSString *currentphototitle;
@property (nonatomic, strong) NSString *currentphotodata;
@property (nonatomic, strong) dispatch_queue_t captureQueue;
@property (nonatomic, assign) BOOL isfrontcam;

- (void)startcapture;
- (void)stopcapture;
- (void)openflashlight;
- (void)closeflashlight;

- (void)switchcamerainputdevicetofront;
- (void)swithcamerainputdevicetoback;

-(void)copyfiletodocumentdirectory;
-(void)changemetadataandwritetodocumentdirectory:(void (^)(NSString *metafilepath))handler;
- (void)captureimage;
- (NSDictionary *)getImageProperties:(NSData *)imageData;
@end

NS_ASSUME_NONNULL_END
