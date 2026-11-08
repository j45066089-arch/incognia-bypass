# Incognia Bypass für Revolut Selfie-KYC

## Problem
LordVCam wird von Incognias **InjectionAttackDetection** erkannt.

## Lösung
Tweak hookt folgende Klassen:

### 1. IncodeInjectionAttackDetection
```objc
- (BOOL)isInjectionDetected → NO
- (void)startCameraInjectionCheck → skip
```

### 2. IncdCameraSpoofDetector
```objc
- (BOOL)isSpoofDetected → NO
```

### 3. IncodeFrameDuplicationDetector
```objc
- (BOOL)areFramesDuplicate → NO
```

### 4. SelfieScannerLivenessChecker
```objc
- (BOOL)isLivenessCheckPassed → YES
- (float)livenessScore → 1.0
```

### 5. OmniSpoofCheck (WICHTIG!)
```objc
- (BOOL)isSpoofDetected → NO
- (OmniSpoofCheckResult)performCheck → Pass
```

### 6. IncdSelfieQualityEstimator (WICHTIG!)
```objc
- (float)qualityScore → 1.0
- (BOOL)isQualityAcceptable → YES
```

### 7. FaceQualityClassificationCheck
```objc
- (BOOL)performCheck → YES
```

### 8. Quality Thresholds
```objc
+ (float)minQualityThreshold → 0.0 (alles akzeptieren)
```

## Build Instructions

### Mit GitHub Actions (empfohlen)
1. Dateien in GitHub Repo pushen
2. Workflow ausführen
3. `.deb` Package herunterladen

### Lokal mit THEOS
```bash
cd /c/Users/shosh/revolut_ghidra
make package
```

## Installation

### Via SSH
```bash
scp IncogniaBypass_1.0-1_iphoneos-arm64.deb mobile@127.0.0.1:/var/tmp/
ssh mobile@127.0.0.1
sudo dpkg -i /var/tmp/IncogniaBypass_1.0-1_iphoneos-arm64.deb
sudo killall -u com.revolut.revolut
```

### Via Filza
1. `.deb` auf iPhone kopieren
2. In Filza öffnen
3. Installieren

## Testing

1. Revolut schließen
2. LordVCam starten
3. Revolut öffnen
4. Luxemburg KYC → Selfie
5. Bewegungen machen (Kopf drehen, blinzeln)

## Debugging

Logs ansehen:
```bash
log stream --predicate 'processImagePath contains "Revolut"' --style compact
```

Suche nach:
```
[IncogniaBypass] Loaded successfully!
```

## Falls es nicht funktioniert

### 1. RootHide konfigurieren
```bash
ssh mobile@127.0.0.1
cd /var/jb/var/mobile/Library/RootHide
cat RootHideConfig.plist
```

`com.revolut.revolut` muss im Blacklist sein!

### 2. DeveloperMode prüfen
```bash
sysctl kern.developer-mode
```

Sollte `0` sein.

### 3. LordVCam prüfen
- Ist LordVCam aktiv?
- Wird das richtige Video angezeigt?
- Ist die Qualität gut (kein Glare, kein Blur)?

## Alternative: Aktive Liveness

Wenn der Tweak nicht reicht, musst du **echte Bewegungen** machen:

1. Kopf nach links/rechts drehen
2. Blinzeln
3. Eventuell Zahlen nachsprechen

Der Tweak umgeht nur die **Injection Detection**, nicht die **Liveness Detection**.

## Dateien
- `IncogniaBypass.xm` - Tweak Source
- `Makefile` - Build Config
- `README.md` - Diese Datei
