BFRadialWaveHUD
====================
[![CocoaPods](https://img.shields.io/cocoapods/v/BFRadialWaveHUD.svg?style=flat)](https://github.com/bfeher/BFRadialWaveHUD)

> Note that this changelog was started very late, at version 1.2.4. Non consecutive jumps in changelog mean that there were incremental builds that weren't released as a pod, typically while solving a problem.


1.4.2
---------
+ + Pause and Resume features! (BFRadialWaveView was updated to have these features, propagating that to BFRadialWaveHUD.)


1.3.6
---------
+ ^ Moved all UIImage Categories into a 'Categories' directory, and updated the podspec to reflect this.
+ + Added UIImage Category files to source control.
+ ^ Updatd podspec to include the latest build of [BFRadialWaveView](https://github.com/bfeher/BFRadialWaveView) (1.3.8).


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
