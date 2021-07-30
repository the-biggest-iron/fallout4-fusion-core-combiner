Scriptname FusionCoreCombiner:Activator_FusionCoreCombiner extends ObjectReference Const

ObjectReference Property FusionCoreCombinerManager Auto Const

Message Property InteractionMessage Auto Const
Message Property IsProcessingMessage Auto Const

Event OnActivate(ObjectReference akActionRef)
    If (akActionRef == Game.GetPlayer())
        FusionCoreCombiner:Activator_CoreCombinerManager Manager = FusionCoreCombinerManager as FusionCoreCombiner:Activator_CoreCombinerManager

        If (Manager.IsProcessing == true)
            IsProcessingMessage.Show(Manager.CurrentProcessing, Manager.TotalProcessing)
        Else
            int Response = InteractionMessage.Show(Manager.TotalCharge, (Manager.TotalCharge / 100) as int)

            If (Response == 1) ; Begin Processing
                (FusionCoreCombinerManager as FusionCoreCombiner:Activator_CoreCombinerManager).BeginProcess()
            ElseIf (Response == 0) ; Open container
                Manager.InputContainer.Activate(Game.GetPlayer())
            ElseIf (Response == 2) ; Create full cores
                (FusionCoreCombinerManager as FusionCoreCombiner:Activator_CoreCombinerManager).GenerateCores()
            EndIf
        EndIf
    EndIf
EndEvent
