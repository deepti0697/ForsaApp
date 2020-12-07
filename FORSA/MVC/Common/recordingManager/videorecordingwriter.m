//
//  VideoRecordingWriter.m
//  CustomVideoRecording
//
//  Created by 郭伟林 on 17/1/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "videorecordingwriter.h"

@interface videorecordingwriter ()

@property (nonatomic, copy, readwrite) NSString *videoPath;

@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *assetVideoInput;


@end

@implementation videorecordingwriter

- (void)dealloc {
    
    _assetWriter     = nil;
    _assetVideoInput = nil;
    _assetAudioInput = nil;
    _videoPath       = nil;
}

+ (instancetype)recordingWriterWithVideoPath:(NSString*)videoPath
                             resolutionWidth:(NSInteger)width
                            resolutionHeight:(NSInteger)height
                                audioChannel:(int)channel
                                  sampleRate:(Float64)rate
                               rotationangle:(CGFloat)angle
{

        return  [[self alloc] initWithVideoPath:videoPath resolutionWidth:width resolutionHeight:height audioChannel:channel sampleRate:rate rotationangle:angle];
}
+ (instancetype)recordingWriterWithVideoPath:(NSString*)videoPath
                             resolutionWidth:(NSInteger)width
                            resolutionHeight:(NSInteger)height
{
        return [[self alloc] initWithVideoPath:videoPath resolutionWidth:width resolutionHeight:height];
}
- (instancetype)initWithVideoPath:(NSString*)videoPath
                  resolutionWidth:(NSInteger)width
                 resolutionHeight:(NSInteger)height
                     audioChannel:(int)channel
                       sampleRate:(Float64)rate
                    rotationangle:(CGFloat)angle
{
        self = [super init];
        if (self) {
                _videoPath = videoPath;
                        // 删除此路径下的文件如果已经存在, 保证文件是最新录制.
                [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
                        // 初始化 AVAssetWriter, 写入媒体类型为 MP4.
                _assetWriter = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:self.videoPath] fileType:AVFileTypeMPEG4 error:nil];
                _assetWriter.shouldOptimizeForNetworkUse = YES;
                
            {
                        // 初始化视频输入.
                        // 配置视频的分辨率, 编码方式等.
                NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecTypeH264, AVVideoCodecKey,
                                          @(width), AVVideoWidthKey,
                                          @(height), AVVideoHeightKey,AVVideoScalingModeResizeAspectFill,AVVideoScalingModeKey, nil];
                _assetVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:settings];
                _assetVideoInput.expectsMediaDataInRealTime = YES; // 调整输入应该处理实时数据源的数据.
                if (angle != 0)
                    {
                      _assetVideoInput.transform = CGAffineTransformMakeRotation(-angle);
                    }
                
                
                [_assetWriter addInput:_assetVideoInput];
            }
                
                if (channel != 0 && rate != 0) {
                                // 初始化音频输入.
                                // 配置音频的AAC, 音频通道, 采样率, 比特率等.
                        NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:@(kAudioFormatMPEG4AAC), AVFormatIDKey,
                                                  @(channel), AVNumberOfChannelsKey,
                                                  @(rate), AVSampleRateKey,
                                                  @(128000), AVEncoderBitRateKey, nil];
                        _assetAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:settings];
                        _assetAudioInput.expectsMediaDataInRealTime = YES;
                        [_assetWriter addInput:_assetAudioInput];
                }
                
        }
        return self;
}


- (instancetype)initWithVideoPath:(NSString*)videoPath resolutionWidth:(NSInteger)width resolutionHeight:(NSInteger)height
{
    self = [super init];
    if (self) {
        _videoPath = videoPath;
        // 删除此路径下的文件如果已经存在, 保证文件是最新录制.
        [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
        // 初始化 AVAssetWriter, 写入媒体类型为 MP4.
        _assetWriter = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:self.videoPath] fileType:AVFileTypeMPEG4 error:nil];
        _assetWriter.shouldOptimizeForNetworkUse = YES;
        
        {
            // 初始化视频输入.
            // 配置视频的分辨率, 编码方式等.
            NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecTypeH264, AVVideoCodecKey,
                                      @(width), AVVideoWidthKey,
                                      @(height), AVVideoHeightKey, AVVideoScalingModeResizeAspectFill,AVVideoScalingModeKey,nil];
            _assetVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:settings];
            _assetVideoInput.expectsMediaDataInRealTime = YES; // 调整输入应该处理实时数据源的数据.
            [_assetWriter addInput:_assetVideoInput];
        }
        
    
    }
    return self;
}
-(void)addaudioinputwithaudioChannel:(int)channel
                  sampleRate:(Float64)rate

{
        if (channel != 0 && rate != 0) {
                        // 初始化音频输入.
                        // 配置音频的AAC, 音频通道, 采样率, 比特率等.
                NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:@(kAudioFormatMPEG4AAC), AVFormatIDKey,
                                          @(channel), AVNumberOfChannelsKey,
                                          @(rate), AVSampleRateKey,
                                          @(128000), AVEncoderBitRateKey, nil];
                _assetAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:settings];
                _assetAudioInput.expectsMediaDataInRealTime = YES;
                if ([_assetWriter canAddInput:_assetAudioInput])
                    {
                      [_assetWriter addInput:_assetAudioInput];
                    }
                
        }
}
-(void)addmetadatawith:(NSString *)videotitle withdecData:(NSString *)dicdata
{
        NSMutableArray *metadata = [NSMutableArray array];
        AVMutableMetadataItem *mi = [AVMutableMetadataItem metadataItem];
        mi.key = AVMetadataCommonKeyTitle;
    
        mi.keySpace = AVMetadataKeySpaceCommon;
        mi.value = videotitle;
    
    AVMutableMetadataItem *midata1 = [AVMutableMetadataItem metadataItem];
    midata1.key = AVMetadataCommonKeyDescription;
    midata1.keySpace = AVMetadataKeySpaceCommon;
    midata1.value = dicdata;
        
    
        [metadata addObject:midata1];
        [metadata addObject:mi];
        [_assetWriter setMetadata:metadata];
}
-(NSString*)generateRandomString:(int)num {
        NSMutableString* string = [NSMutableString stringWithCapacity:num];
        for (int i = 0; i < num; i++) {
                [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(26))];
        }
        return string;
}
- (BOOL)writeWithSampleBuffer:(CMSampleBufferRef)sampleBuffer isVideo:(BOOL)isVideo {
    
    BOOL isSuccess = NO;
    if (CMSampleBufferDataIsReady(sampleBuffer)) {
        if (_assetWriter.status == AVAssetWriterStatusUnknown && isVideo) { // 保证首先写入的是视频..
                // this is necessary to call startwriting to avoid crash
                [_assetWriter startWriting];
            [_assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
        }
        if (_assetWriter.status == AVAssetWriterStatusFailed) {
            NSLog(@"write error %@", _assetWriter.error.localizedDescription);
            isSuccess = NO;
        }
        
        if (isVideo) {
            if (_assetVideoInput.readyForMoreMediaData) {
                [_assetVideoInput appendSampleBuffer:sampleBuffer];
                isSuccess = YES;
            }
        } else {
            if (_assetAudioInput.readyForMoreMediaData) {
                [_assetAudioInput appendSampleBuffer:sampleBuffer];
                isSuccess = YES;
            }
        }
    }
    return isSuccess;
}

- (void)finishWritingWithCompletionHandler:(void (^)(void))handler {
        [_assetVideoInput markAsFinished];
        [_assetAudioInput markAsFinished];
        
    [_assetWriter finishWritingWithCompletionHandler:handler];
}

@end
