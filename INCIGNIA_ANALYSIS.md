# Incognia/Incode Onboarding - Deep Analysis

## Overview
Revolut uses **Incognia** (now "Incode") SDK for KYC/Onboarding verification. This is a sophisticated liveness and document verification system.

## Key Components Found

### 1. **Camera Spoof Detection**
```objc
$s14IncdOnboarding19CameraSpoofDetectorP
$s14IncdOnboarding24FrameDuplicationDetectorP
$s14IncdOnboarding24InjectionAttackDetectionP
```
- **CameraSpoofDetector**: Detects if camera feed is spoofed (screen replay, virtual camera)
- **FrameDuplicationDetector**: Checks for duplicate frames (video replay attack)
- **InjectionAttackDetection**: Detects camera feed injection (tweak/vcam)

### 2. **Liveness Detection**
```objc
$s13FourthlineSDK28SelfieScannerLivenessCheckerP
$s13FourthlineSDK34SelfieScannerLivenessStateObserverP
$s13FourthlineSDK25SelfieScannerLivenessViewP
```
- **SelfieScannerLivenessChecker**: Real-time liveness detection during selfie capture
- Checks for:
  - Head movement
  - Face angle changes
  - Eye blinking
  - Natural motion patterns

### 3. **Face Detection & Analysis**
```objc
$s14IncdOnboarding12FaceDetectorP
So22FaceAttributesDetectorC
IncdFaceAttributesDetector
```
**Face Attributes Checked:**
```
_maxFaceAreaCheck
_closedEyeCheck
_headwearCheck
_faceAngleCheck
_lensesCheck
_faceMaskCheck
_spoofCheck
_imageQualityCheck
_faceOcclusionCheck
```

### 4. **Document Verification**
```objc
$s13FourthlineSDK26DocumentValidatorInterfaceP
$s13FourthlineSDK22DocumentScannerInterfaceP
$s13FourthlineSDK24DocumentScannerInterfaceP
```
**Document Types:**
- Passport
- ID Card (front/back)
- Driver's License
- MRZ (Machine Readable Zone) validation

### 5. **Government Validation**
```objc
GovernmentValidationModule
GovernmentValidationResult
OmniProcessGovernmentValidation
OmniProcessGovernmentValidationResponse
```
- Cross-references with government databases
- CURP validation (Mexico)
- INE validation (Mexico)

### 6. **Watchlist Validation**
```objc
incodeWatchlistValidationProgress
watchlistValidation
```
- Checks against sanctions lists
- PEP (Politically Exposed Persons)
- Adverse media

### 7. **NFC Validation**
```objc
nfcValidation
$s13FourthlineNFC24NFCDocumentReaderSessionP
$s13FourthlineNFC22NFCKeyExchangeProtocolP
```
- Reads NFC chip in passports/ID cards
- Verifies chip signature
- Extracts chip data

### 8. **OCR Validation**
```objc
ocrValidation
$s14FourthlineCore18MRZParserInterfaceP
$s14FourthlineCore23DocumentParserInterfaceP
```
- Extracts text from documents
- Validates MRZ format
- Checks checksums

## Detection Flow

### Selfie Capture Flow
```
1. FaceDetector → detects face in camera feed
2. CameraSpoofDetector → checks if camera is real
3. FrameDuplicationDetector → checks for replay attacks
4. InjectionAttackDetection → checks for feed injection
5. SelfieScannerLivenessChecker → liveness verification
6. FaceAttributesDetector → validates face attributes
7. GovernmentValidation → optional gov database check
```

### Document Scan Flow
```
1. DocumentScanner → captures document image
2. DocumentValidator → validates document format
3. MRZParser → extracts and validates MRZ
4. NFCReader → reads chip (if available)
5. OCRValidation → extracts text
6. GovernmentValidation → cross-reference
```

## Key Variables

### Spoof Detection
```objc
spoofDetected
blurDetected
disableLocalGlareCheck
canCheckPermissions
isIDIOUCheckEnabled
startCameraInjectionCheck
_shouldShowNoIDDetectedView
```

### Face Detection
```objc
analyzerChecks
detectdFrontIDCount
idDetection
idDetectionResult
checkForPermissionsEnabled
```

### Validation State
```objc
imgValidationStatus
txtValidationStatus
checkImageView
securityImageView
checkBoxLabel
optinCheckbox
firstScanCheckImageView
secondScanCheckImageView
```

### Detection Results
```objc
idFrontDetected
idBackDetected
passportDetected
checkBox
rootLayer
serverValidationEnabled
_isValidationEnabled
maxValidationCount
validationCount
validationChecks
```

## Bypass Strategies

### 1. **Hook CameraSpoofDetector**
```objc
%hook IncdCameraSpoofDetector
- (BOOL)isSpoofDetected {
    return NO;
}
- (void)detectSpoofWithCompletion:(void(^)(BOOL))completion {
    completion(NO);
}
%end
```

### 2. **Hook FrameDuplicationDetector**
```objc
%hook IncdFrameDuplicationDetector
- (BOOL)areFramesDuplicate {
    return NO;
}
%end
```

### 3. **Hook InjectionAttackDetection**
```objc
%hook IncodeInjectionAttackDetection
- (BOOL)isInjectionDetected {
    return NO;
}
- (SpoofDetectionResult)detectInjection {
    return SpoofDetectionResultNone;
}
%end
```

### 4. **Hook Liveness Checker**
```objc
%hook SelfieScannerLivenessChecker
- (BOOL)isLivenessCheckPassed {
    return YES;
}
- (void)checkLivenessWithCompletion:(void(^)(BOOL))completion {
    completion(YES);
}
%end
```

### 5. **Hook Face Attributes**
```objc
%hook FaceAttributesDetector
- (BOOL)isFaceValid {
    return YES;
}
- (NSDictionary*)detectAttributes {
    return @{
        @"blurDetected": @NO,
        @"lensesDetected": @NO,
        @"faceMaskDetected": @NO,
        @"closedEyesDetected": @NO,
        @"headCoverDetected": @NO
    };
}
%end
```

## SDK Structure

### Frameworks Used
```
FourthlineCore
FourthlineNFC
FourthlineVision
FourthlineSDK
IncdOnboarding
```

### Key Protocols
```objc
$s14IncdOnboarding19CameraSpoofDetectorP
$s14IncdOnboarding24FrameDuplicationDetectorP
$s14IncdOnboarding24InjectionAttackDetectionP
$s14IncdOnboarding12FaceDetectorP
$s14IncdOnboarding20IDValidationDelegateP
```

## API Endpoints Found
```
/kyc/data-point-validation
/upload
/check-in-app-call
/validation-results
```

## Recommendations

### Priority 1: Camera Injection Detection
The `InjectionAttackDetection` is likely the main blocker for virtual cameras. Hook this first.

### Priority 2: Frame Duplication
If using a recorded video, `FrameDuplicationDetector` will catch it. Need to either:
- Use real camera feed
- Hook the detector

### Priority 3: Liveness Check
If static image is used, liveness check will fail. Need to:
- Use video with movement
- Hook the liveness checker

### Priority 4: Document Validation
Less critical for the "device unsafe" alert, but needed for full KYC bypass.

## Next Steps

1. **Build Tweak** that hooks all Incognia detectors
2. **Test with Dopamine** RootHide enabled
3. **Verify** camera feed is not detected as virtual
4. **Check** if liveness detection passes

## Files
- `incognia_strings.txt` - All Incognia-related strings (47MB)
- `INCIGNIA_ANALYSIS.md` - This document
