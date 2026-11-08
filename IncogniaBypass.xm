// IncogniaBypass.xm - Fourthline Upload + Local Checks
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

%hook NetworkUploadSelfieVideoWorker
- (void)uploadCompletedWithResult:(id)result error:(NSError *)error {
    %log; NSLog(@"[IncogniaBypass] Video upload: %@", error ? @"FAILED" : @"SUCCESS");
    [self uploadCompletedWithResult:result error:nil];
}
- (void)handleUploadResponse:(NSDictionary *)response {
    %log; NSMutableDictionary *m = [response mutableCopy];
    [m setObject:@(YES) forKey:@"success"]; [m setObject:@(YES) forKey:@"isValid"];
    [m removeObjectForKey:@"error"]; [m removeObjectForKey:@"errorMessage"];
    %orig(m);
}
%end

%hook NetworkUploadSelfiePictureWorker
- (void)uploadCompletedWithResult:(id)result error:(NSError *)error {
    %log; NSLog(@"[IncogniaBypass] Photo upload: %@", error ? @"FAILED" : @"SUCCESS");
    [self uploadCompletedWithResult:result error:nil];
}
- (void)handleUploadResponse:(NSDictionary *)response {
    %log; NSMutableDictionary *m = [response mutableCopy];
    [m setObject:@(YES) forKey:@"success"]; [m setObject:@(YES) forKey:@"isValid"];
    [m removeObjectForKey:@"error"]; [m removeObjectForKey:@"errorMessage"];
    %orig(m);
}
%end

%hook NetworkQesUploadSelfieWorker
- (void)uploadCompletedWithResult:(id)result error:(NSError *)error {
    %log; NSLog(@"[IncogniaBypass] QES upload: %@", error ? @"FAILED" : @"SUCCESS");
    [self uploadCompletedWithResult:result error:nil];
}
- (void)handleUploadResponse:(NSDictionary *)response {
    %log; NSMutableDictionary *m = [response mutableCopy];
    [m setObject:@(YES) forKey:@"success"]; [m setObject:@(YES) forKey:@"isValid"];
    [m removeObjectForKey:@"error"]; %orig(m);
}
%end

%hook UploadKycWorker
- (void)uploadCompletedWithResult:(id)result error:(NSError *)error {
    %log; NSLog(@"[IncogniaBypass] KYC upload: %@", error ? @"FAILED" : @"SUCCESS");
    [self uploadCompletedWithResult:result error:nil];
}
%end

%hook NetworkUploadKycPersonWorker
- (void)uploadCompletedWithResult:(id)result error:(NSError *)error {
    %log; NSLog(@"[IncogniaBypass] Person upload: %@", error ? @"FAILED" : @"SUCCESS");
    [self uploadCompletedWithResult:result error:nil];
}
%end

%hook SelfieUploader
- (void)uploadCompletedWithResult:(id)result error:(NSError *)error {
    %log; NSLog(@"[IncogniaBypass] SelfieUploader: %@", error ? @"FAILED" : @"SUCCESS");
    [self uploadCompletedWithResult:result error:nil];
}
%end

%hook PersonUploader
- (void)uploadCompletedWithResult:(id)result error:(NSError *)error {
    %log; NSLog(@"[IncogniaBypass] PersonUploader: %@", error ? @"FAILED" : @"SUCCESS");
    [self uploadCompletedWithResult:result error:nil];
}
%end

%hook NSURLSession
- (void)task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    %log;
    if (error) {
        NSURL *url = task.originalRequest.URL;
        if (url && [url.absoluteString rangeOfString:@"selfie" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            NSLog(@"[IncogniaBypass] Selfie upload error: %@", error.localizedDescription);
        }
    }
    %orig;
}
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
