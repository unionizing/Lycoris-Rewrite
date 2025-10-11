# Deepwoken Rewrite
**Module diff vs. previous snapshot: +0/-0/~1 (added/removed/changed)**
```diff
+ (changed) WeaponTest
```

**Timing diff vs. previous snapshot: +7/-0/~6 (animation: +7/-0/~6)**
```diff
+ (changed) Animation : FlameRepulsion
+ (changed) Animation : RisingFlameWindup
+ (added) Animation : KrulianKnifeCrit
+ (changed) Animation : 1_GenericFistAerial
+ (changed) Animation : SlientheartLightRelentless
+ (added) Animation : ToonsM1_3
+ (added) Animation : ToonsM1_2
+ (added) Animation : ToonsM1_1
+ (added) Animation : ToonsCrit
+ (added) Animation : ToonsCrit2
+ (added) Animation : ToonsCritAerial
+ (changed) Animation : 1_GenericGreatAxe2
+ (changed) Animation : 1_GenericHeavyAerial
```

**New features?**
```diff
- (bug fix) Fixed a bug where Target Selection "Ignore Players" == Tween To Back "Ignore Players" and broke AP
- (bug fix) Fixed a bug where Battle Royale ESP would not be detected properly
- (bug fix) Fixed a bug where Tween To Back's Sticky Targets would not switch targets after turning it off
- (bug fix) Fixed a bug where 'Finder' utility broke and Player Scanning would not work as intended
- (removed) Removed hit detection (e.g blood effects) from AP because it did not mean the move would cancel anyway and usually never triggered usually
+ (added) New BloxstrapRPC big & small logo
```

*Your commit ID should == "b099b4" when the update is fully pushed to you.*