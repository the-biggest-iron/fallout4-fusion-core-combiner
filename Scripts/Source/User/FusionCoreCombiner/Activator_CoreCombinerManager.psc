Scriptname FusionCoreCombiner:Activator_CoreCombinerManager extends ObjectReference

Group Keywords
    Keyword Property InputContainerKeyword Auto Const
EndGroup

Group Ammo
    Ammo Property AmmoFusionCore Auto Const
EndGroup

Message Property AtLeastOneCoreRequiredMessage Auto Const
Message Property NeedsAtLeastOneFullMessage Auto Const

Message Property ProcessingStart Auto Const
Message Property ProcessingEnd Auto Const

int Property TotalCharge = 0 Auto
bool Property IsProcessing = false Auto

int Property CurrentProcessing = 0 Auto
int Property TotalProcessing = 0 Auto

ObjectReference Property InputContainer
    ObjectReference Function Get()
        Return GetLinkedRef(InputContainerKeyword)
    EndFunction
EndProperty

Function BeginProcess()
    If (IsProcessing)
        Return
    EndIf

    If (InputContainer.GetItemCount(AmmoFusionCore) <= 0)
        AtLeastOneCoreRequiredMessage.Show()
        Return
    EndIf

    IsProcessing = true

    int FusionCoreCount = InputContainer.GetItemCount(AmmoFusionCore)
    int CoreIndex = 0

    ProcessingStart.Show(FusionCoreCount)

    TotalProcessing = FusionCoreCount

    While (CoreIndex < FusionCoreCount)
        ObjectReference CoreRef = InputContainer.DropObject(AmmoFusionCore)

        CoreRef.Disable()

        float HealthPercent = CoreRef.GetItemHealthPercent()

        If (HealthPercent < 0) ; Full core
            TotalCharge += 100
        ElseIf (HealthPercent > 0)
            TotalCharge += (HealthPercent * 100) as int
        EndIf

        ; Debug.Notification((HealthPercent * 100) as int)

        CoreRef.Delete()

        CurrentProcessing = CoreIndex + 1

        CoreIndex += 1
    EndWhile

    IsProcessing = false
    ProcessingEnd.Show(FusionCoreCount)
    InputContainer.RemoveAllItems(Game.GetPlayer(), true)
EndFunction

Function GenerateCores()
    If (TotalCharge < 100)
        NeedsAtLeastOneFullMessage.Show()
        Return
    EndIf

    int TotalCores = (TotalCharge / 100) as int

    TotalCharge -= TotalCores * 100

    Game.GetPlayer().AddItem(AmmoFusionCore, TotalCores)
EndFunction
