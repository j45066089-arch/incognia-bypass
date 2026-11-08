//
//  IncogniaBypass.xm
//  Hook Incognia/Incode Selfie Detection for LordVCam
//
//  Compile with: make package
//  Install via: dpkg -i IncogniaBypass_1.0-1_iphoneos-arm64.deb
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// ============================================================================
// InjectionAttackDetection Bypass
// ============================================================================

%hook IncodeInjectionAttackDetection

- (BOOL)isInjectionDetected {
    %log;
    return NO;  // Always return NO to bypass injection detection
}

- (SpoofDetectionResult)detectInjection {
    %log;
    return SpoofDetectionResultNone;  // or 0
}

- (void)detectInjectionWithCompletion:(void(^)(BOOL, NSError *))completion {
    %log;
    completion(NO, nil);  // No injection detected
}

- (void)startCameraInjectionCheck {
    %log;
    // Do nothing - skip the check
}

%end

// ============================================================================
// CameraSpoofDetector Bypass  
// ============================================================================

%hook IncdCameraSpoofDetector

- (BOOL)isSpoofDetected {
    %log;
    return NO;
}

- (BOOL)detectSpoof {
    %log;
    return NO;
}

- (void)detectSpoofWithCompletion:(void(^)(BOOL))completion {
    %log;
    completion(NO);
}

- (CameraSpoofDetectorError)error {
    return nil;
}

%end

// ============================================================================
// FrameDuplicationDetector Bypass
// ============================================================================

%hook IncodeFrameDuplicationDetector

- (BOOL)areFramesDuplicate {
    %log;
    return NO;
}

- (FrameDuplicationResult)detectFrameDuplication {
    %log;
    return FrameDuplicationResultNone;  // or 0
}

- (void)detectWithCompletion:(void(^)(BOOL))completion {
    %log;
    completion(NO);  // No duplication
}

%end

// ============================================================================
// SelfieScannerLivenessChecker Bypass
// ============================================================================

%hook SelfieScannerLivenessChecker

- (BOOL)isLivenessCheckPassed {
    %log;
    return YES;
}

- (BOOL)checkLiveness {
    %log;
    return YES;
}

- (void)checkLivenessWithCompletion:(void(^)(BOOL))completion {
    %log;
    completion(YES);
}

- (float)livenessScore {
    return 1.0f;  // Maximum score
}

%end

// ============================================================================
// KycSelfieScannerLivenessChecker Bypass (v2)
// ============================================================================

%hook KycSelfieScannerLivenessChecker

- (BOOL)isLivenessCheckPassed {
    %log;
    return YES;
}

- (void)checkLivenessWithCompletion:(void(^)(BOOL))completion {
    %log;
    completion(YES);
}

%end

// ============================================================================
// OmniSpoofCheck Bypass
// ============================================================================

%hook OmniSpoofCheck

- (BOOL)isSpoofDetected {
    %log;
    return NO;
}

- (OmniSpoofCheckResult)performCheck {
    %log;
    return OmniSpoofCheckResultPass;  // or 0
}

- (void)performCheckWithCompletion:(void(^)(BOOL))completion {
    %log;
    completion(NO);  // No spoof
}

- (OmniSpoofCheckReason)spoofReason {
    return OmniSpoofCheckReasonNone;  // or 0
}

%end

// ============================================================================
// IncdSelfieQualityEstimator Bypass
// ============================================================================

%hook IncdSelfieQualityEstimator

- (float)qualityScore {
    %log;
    return 1.0f;  // Maximum quality
}

- (BOOL)isQualityAcceptable {
    %log;
    return YES;
}

- (void)estimateQualityWithCompletion:(void(^)(float, BOOL))completion {
    %log;
    completion(1.0f, YES);
}

- (NSDictionary *)qualityMetrics {
    %log;
    return @{
        @"blurScore": @1.0,
        @"glareScore": @1.0,
        @"overallQuality": @1.0
    };
}

%end

// ============================================================================
// SelfieFaceQualityEstimator Bypass
// ============================================================================

%hook SelfieFaceQualityEstimator

- (float)estimateQuality {
    %log;
    return 1.0f;
}

- (BOOL)isQualityValid {
    %log;
    return YES;
}

%end

// ============================================================================
// FaceQualityClassificationCheck Bypass
// ============================================================================

%hook FaceQualityClassificationCheck

- (BOOL)performCheck {
    %log;
    return YES;
}

- (FaceQualityClassificationResult)result {
    return FaceQualityClassificationResultPass;  // or 0
}

%end

// ============================================================================
// Quality Threshold Overrides
// ============================================================================

%hook FaceQualityThresholds

+ (float)minQualityThreshold {
    return 0.0f;  // Accept any quality
}

+ (float)blurThreshold {
    return 0.0f;
}

+ (float)glareThreshold {
    return 0.0f;
}

%end

%hook RevVisionFaceQualityThresholds

+ (float)qualityThreshold {
    return 0.0f;
}

%end

// ============================================================================
// Image Quality Check Bypass
// ============================================================================

%hook ImageQualityCheck

- (BOOL)performCheck {
    %log;
    return YES;
}

- (BOOL)isQualityValid {
    return YES;
}

%end

// ============================================================================
// Document/Face Quality Classification
// ============================================================================

%hook DocumentQualityClassificationCheck

- (BOOL)performCheck {
    %log;
    return YES;
}

%end

// ============================================================================
// Closed Eyes Check Bypass
// ============================================================================

%hook ClosedEyesCheck

- (BOOL)areEyesClosed {
    %log;
    return NO;
}

- (BOOL)performCheck {
    return YES;
}

%end

// ============================================================================
// Occlusion Check Bypass
// ============================================================================

%hook OcclusionCheck

- (BOOL)isOccluded {
    %log;
    return NO;
}

- (BOOL)performCheck {
    return YES;
}

%end

// ============================================================================
// IncdFaceDetector Bypass
// ============================================================================

%hook IncdFaceDetector

- (BOOL)hasDetectedFace {
    %log;
    return YES;
}

- (void)detectFacesWithCompletion:(void(^)(BOOL))completion {
    %log;
    completion(YES);
}

%end

// ============================================================================
// Active Liveness Bypass
// ============================================================================

%hook ActiveLivenessViewController

- (void)livenessCheckCompleted:(BOOL)passed {
    %log;
    [self livenessCheckCompleted:YES];  // Force pass
}

- (void)livenessCheckFailed:(NSError *)error {
    %log;
    // Ignore failure
}

%end

// ============================================================================
// DepthData Bypass (for devices with depth camera)
// ============================================================================

%hook FourthlineVisionDepthData

- (BOOL)hasValidDepthData {
    %log;
    return YES;
}

%end

// ============================================================================
// Global Settings Overrides
// ============================================================================

%hook NSUserDefaults

- (id)objectForKey:(NSString *)key {
    id result = %orig;
    
    // Force disable various checks
    if ([key isEqualToString:@"orchestratedLivenessCheckEnabled"]) {
        return @NO;
    }
    if ([key isEqualToString:@"performLocalLiveness"]) {
        return @NO;
    }
    if ([key isEqualToString:@"useClientGlare"]) {
        return @NO;
    }
    if ([key isEqualToString:@"visionDisableActiveLivenessValidation"]) {
        return @YES;
    }
    
    return result;
}

%end

// ============================================================================
// Logging
// ============================================================================

%hook NSBundle
- (id)infoDictionary {
    %init {
        NSLog(@"[IncogniaBypass] Loaded successfully!");
        NSLog(@"[IncogniaBypass] LordVCam should now work for selfie verification!");
    }
    return %orig;
}
%end
