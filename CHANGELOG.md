BFRadialWaveHUD
====================
[![CocoaPods](https://img.shields.io/cocoapods/v/BFRadialWaveHUD.svg?style=flat)](https://github.com/bfeher/BFRadialWaveHUD)

> Note that this changelog was started very late, at version 1.2.4 Previous changes are lost to the All Father, forever to be unknown.


1.2.10
---------
+ ^ Moved BFRadialWaveHUD.xib, and all UIImage Categories into a 'Resources' directory, and updated the podspec to reflect this.


1.2.9
---------
+ ^ Moved BFRadialWaveHUD.xib to podspec resources.


1.2.8
---------
+ ^ Fixed podspec bug. Podspec now includes the necessary BFRadialWaveHUD.xib file.


1.2.7
---------
+ ^ Fixed podspec bug, preventing pod from passing build.


1.2.5
---------
+ ^ Put KVN files into Classes folder to fix sourcing issue.


1.2.4
---------
+ + Added a changelog!
+ + Added cocoapod support!
- - Removed `- (void)updateProgressCircleColor:(UIColor *)color` and replaced it with the property `UIColor *progressCircleColor`.
+ ^ Fixed bug where checkmarkColor and crossColor weren't being updated properly.
