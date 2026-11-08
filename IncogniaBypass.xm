//
//  IncogniaBypass.xm
//  Hook Incognia/Incode Selfie Detection for LordVCam
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

%hook IncodeInjectionAttackDetection
- (BOOL)isInjectionDetected { %log; return NO; }
- (void)detectInjectionWithCompletion:(void(^)(BOOL, NSError *))completion { %log; completion(NO, nil); }
%end

%hook IncdCameraSpoofDetector
- (BOOL)isSpoofDetected { %log; return NO; }
- (BOOL)detectSpoof { %log; return NO; }
- (void)detectSpoofWithCompletion:(void(^)(BOOL))completion { %log; completion(NO); }
%end

%hook IncodeFrameDuplicationDetector
- (BOOL)areFramesDuplicate { %log; return NO; }
- (void)detectWithCompletion:(void(^)(BOOL))completion { %log; completion(NO); }
%end

%hook SelfieScannerLivenessChecker
- (BOOL)isLivenessCheckPassed { %log; return YES; }
- (BOOL)checkLiveness { %log; return YES; }
- (void)checkLivenessWithCompletion:(void(^)(BOOL))completion { %log; completion(YES); }
- (float)livenessScore { return 1.0f; }
%end

%hook KycSelfieScannerLivenessChecker
- (BOOL)isLivenessCheckPassed { %log; return YES; }
- (void)checkLivenessWithCompletion:(void(^)(BOOL))completion { %log; completion(YES); }
%end

%hook OmniSpoofCheck
- (BOOL)isSpoofDetected { %log; return NO; }
- (void)performCheckWithCompletion:(void(^)(BOOL))completion { %log; completion(NO); }
%end

%hook IncdSelfieQualityEstimator
- (float)qualityScore { %log; return 1.0f; }
- (BOOL)isQualityAcceptable { %log; return YES; }
- (void)estimateQualityWithCompletion:(void(^)(float, BOOL))completion { %log; completion(1.0f, YES); }
- (NSDictionary *)qualityMetrics { return @{@"blurScore": @1.0, @"glareScore": @1.0, @"overallQuality": @1.0}; }
%end

%hook SelfieFaceQualityEstimator
- (float)estimateQuality { %log; return 1.0f; }
- (BOOL)isQualityValid { %log; return YES; }
%end

%hook FaceQualityClassificationCheck
- (BOOL)performCheck { %log; return YES; }
%end

%hook FaceQualityThresholds
+ (float)minQualityThreshold { return 0.0f; }
+ (float)blurThreshold { return 0.0f; }
+ (float)glareThreshold { return 0.0f; }
%end

%hook RevVisionFaceQualityThresholds
+ (float)qualityThreshold { return 0.0f; }
%end

%hook ImageQualityCheck
- (BOOL)performCheck { %log; return YES; }
- (BOOL)isQualityValid { return YES; }
%end

%hook DocumentQualityClassificationCheck
- (BOOL)performCheck { %log; return YES; }
%end

%hook ClosedEyesCheck
- (BOOL)areEyesClosed { %log; return NO; }
- (BOOL)performCheck { return YES; }
%end

%hook OcclusionCheck
- (BOOL)isOccluded { %log; return NO; }
- (BOOL)performCheck { return YES; }
%end

%hook IncdFaceDetector
- (BOOL)hasDetectedFace { %log; return YES; }
- (void)detectFacesWithCompletion:(void(^)(BOOL))completion { %log; completion(YES); }
%end

%hook FourthlineVisionDepthData
- (BOOL)hasValidDepthData { %log; return YES; }
%end

%hook NSUserDefaults
- (id)objectForKey:(NSString *)key {
    id result = %orig;
    if ([key isEqualToString:@"orchestratedLivenessCheckEnabled"]) return @NO;
    if ([key isEqualToString:@"performLocalLiveness"]) return @NO;
    if ([key isEqualToString:@"useClientGlare"]) return @NO;
    if ([key isEqualToString:@"visionDisableActiveLivenessValidation"]) return @YES;
    return result;
}
%end

%hook NSBundle
- (id)infoDictionary {
    %init {
        NSLog(@"[IncogniaBypass] Loaded successfully!");
        NSLog(@"[IncogniaBypass] LordVCam selfie bypass active!");
    }
    return %orig;
}
%end
