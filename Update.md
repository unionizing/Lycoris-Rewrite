# Deepwoken Rewrite
**Module diff vs. previous snapshot: +13/-0/~36 (added/removed/changed)**
```diff
+ (added) AirForce
+ (added) CrimsonRainRecall
+ (added) GaleHeroblade
+ (added) IronQuills
+ (added) LordsSlice
+ (added) NeedleBarrage
+ (added) RailbladeAerialCrit
+ (added) RailbladeCrit
+ (added) RifleSpear
+ (added) TableFlip
+ (added) TitusSkycrashGo
+ (added) WindCarve
+ (added) WraithclawCrit
+ (changed) MetalRush
+ (changed) TitusSkycrash
+ (changed) ChainPull
+ (changed) Edenstaff
+ (changed) RapidSlashes
+ (changed) WeaponAerialAttackTest
+ (changed) EthironBeam
+ (changed) RocketLance
+ (changed) SilentheartHeavyMayhem
+ (changed) FlameBallista
+ (changed) PrimadonGrab
+ (changed) LightningHerCrit
+ (changed) HeavenlyWind
+ (changed) WeaponTest
+ (changed) IceLance
+ (changed) TitusDrive
+ (changed) JusKaritaCritical
+ (changed) PressureBlast
+ (changed) PrimadonStomp
+ (changed) Rockmaller
+ (changed) TwisterKicks
+ (changed) BoneBoyBoneFloor
+ (changed) FirePalm
+ (changed) IronSlam
+ (changed) IceEruption
+ (changed) SharkoCero
+ (changed) PrimadonTripleStomp
+ (changed) RisingThunder
+ (changed) SanguineDive
+ (changed) ShadowEruptionCast
+ (changed) GroundSlideSilentheart
+ (changed) IceForgeNewCharge
+ (changed) WeaponRunningAttackTest
+ (changed) LightningStream
+ (changed) WindGun
+ (changed) PrimadonPunch
```

**Timing diff vs. previous snapshot: +4/-2/~44 (animation: +2/-1/~38, part: +2/-1/~6)**
```diff
+ (changed) Animation : FrostGrabWindup (by Juanito)
+ (changed) Animation : BoneBoyRushWindup (by Juanito)
+ (changed) Animation : BoneBoyRushGo (by Juanito)
+ (changed) Animation : EnforcerSwing1 (by Juanito)
+ (changed) Animation : RailbladeCritAerial (by Juanito)
+ (changed) Animation : ChorusCrit (by Juanito)
+ (changed) Animation : ShoulderBashGo (by Juanito)
+ (changed) Animation : 1_GenericKarita1 (by Juanito)
+ (changed) Animation : IceCarveSpin (by Juanito)
+ (changed) Animation : ShadowHb (by Juanito)
+ (changed) Animation : DreadWhisper (by Juanito)
+ (changed) Animation : Twincleave (by Juanito)
- (removed) Animation : FireGun (by Juanito)
+ (changed) Animation : PhoenixSlam (by Juanito)
+ (changed) Animation : UmbriteCrit (by Juanito)
+ (changed) Animation : ClutchingShadow (by Juanito)
+ (changed) Animation : DarkBlade (by Juanito)
+ (changed) Animation : TitusGroundStomp (by Juanito)
+ (changed) Animation : WindBlade (by Juanito)
+ (changed) Animation : Updraft (by Juanito)
+ (changed) Animation : ScytheRunning (by Juanito)
+ (changed) Animation : SoulflareSiphon (by Juanito)
+ (changed) Animation : MaliceCrit (by Juanito)
+ (changed) Animation : MaliceAerial (by Juanito)
+ (changed) Animation : MaliceRunning (by Juanito)
+ (changed) Animation : SharkoQuadSwipe (by Juanito)
+ (changed) Animation : SquidwardSlash2 (by Juanito)
+ (changed) Animation : SquidwardSlash1 (by Juanito)
+ (changed) Animation : SquidwardSlash3 (by Juanito)
+ (changed) Animation : OwlPrimeExplosion (by Juanito)
+ (changed) Animation : OwlPrimeStomp (by Juanito)
+ (added) Animation : OwlPrimeSwipe (by Juanito)
+ (changed) Animation : EthironPunch (by Juanito)
+ (changed) Animation : ContractorWhip (by Juanito)
+ (changed) Animation : FlarebloodCrit (by Juanito)
+ (added) Animation : Heartwing (by Juanito)
+ (changed) Animation : CrimsonSurge (by Juanito)
+ (changed) Animation : RazorBlitz (by Juanito)
+ (changed) Animation : AstralWind (by Blastbrean)
+ (changed) Animation : ShoulderBashWindup (by Blastbrean)
+ (changed) Animation : WindCarve (by Blastbrean)
+ (changed) Part : Shard (by Juanito)
+ (changed) Part : FireBullet (by Juanito)
- (removed) Part : MetalRod2 (by Juanito)
+ (changed) Part : ShadowSeekers (by Juanito)
+ (added) Part : GaleTrap (by Juanito)
+ (changed) Part : WindBlade (by Juanito)
+ (added) Part : EthironBomb (by Juanito)
+ (changed) Part : ScarletCannon (by Juanito)
+ (changed) Part : CrimsonSurge (by Juanito)
```

**New features?**
```diff
+ (added) Experimental auto feint feature (issues are known related to ping.)
+ (added) Vent fallback 
+ (added) Feint flourish
+ (added) No attacking client checks
+ (added) Extend roll cancel frames
+ (added) Auto sprint on crouch toggle
+ (added) Chain of perfection counter
+ (added) Disable "Auto Defense" during chime countdown
+ (changed) Allow failure section is now unhidden (report any issues related to)
+ (changed) New attacking check (issues are known related to ping; uses animation to detect attacks.)
+ (changed) New parry / block queue system (report any issues to forced blocking + gb, not allowing manual parries / blocking)
+ (changed) Optimized more of the Auto Defense system using LPH_NO_VIRTUALIZE
- (bug fix) OwnershipWatcher now falls back if the exploit has no 'isnetworkowner'
- (bug fix) Default features that are automatically on have been turned off which conflict with "Silent Mode"
- (bug fix) All effect removals should now work as intended. Please be careful if you had features like "No Stun" on. They are super blatant.
```
*Repeat parries should have fully fixed FPS drops.* 
*For L2F2, the main performance issue seemed to be related to the hitbox check.*

*Your commit ID should be "5b133d" when the update is pushed to you.*