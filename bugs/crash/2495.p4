/*Invoking preprocessor
cpp -C -undef -nostdinc -x assembler-with-cpp  -D__TARGET_BMV2__ -I/mnt/windows/Projekte/p4_tv/modules/p4c/build/p4include bugs/crash/empty_table_miss.p4.txt
FrontEnd_0_P4V1::getV1ModelVersion
ParseAnnotationBodies_0_ParseAnnotations
ParseAnnotationBodies_1_ClearTypeMap
FrontEnd_1_ParseAnnotationBodies
FrontEnd_2_PrettyPrint
FrontEnd_3_ValidateParsedProgram
FrontEnd_4_CreateBuiltins
FrontEnd_5_ResolveReferences
ConstantFolding_0_DoConstantFolding
FrontEnd_6_ConstantFolding
InstantiateDirectCalls_0_ResolveReferences
InstantiateDirectCalls_1_DoInstantiateCalls
FrontEnd_7_InstantiateDirectCalls
FrontEnd_8_ResolveReferences
Deprecated_0_ResolveReferences
Deprecated_1_CheckDeprecated
FrontEnd_9_Deprecated
FrontEnd_10_CheckNamedArgs
FrontEnd_11_TypeInference
FrontEnd_12_ValidateMatchAnnotations
BindTypeVariables_0_ClearTypeMap
BindTypeVariables_1_ResolveReferences
BindTypeVariables_2_TypeInference
BindTypeVariables_3_DoBindTypeVariables
FrontEnd_13_BindTypeVariables
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
DefaultArguments_0_TypeChecking
DefaultArguments_1_DoDefaultArguments
FrontEnd_14_DefaultArguments
FrontEnd_15_ResolveReferences
FrontEnd_16_TypeInference
RemoveParserControlFlow_0_DoRemoveParserControlFlow
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
SimplifyControlFlow_0_TypeChecking
SimplifyControlFlow_1_DoSimplifyControlFlow
P4::TypeChecking_2_ResolveReferences
P4::TypeChecking_3_TypeInference
SimplifyControlFlow_2_TypeChecking
SimplifyControlFlow_3_DoSimplifyControlFlow
RemoveParserControlFlow_1_SimplifyControlFlow
RemoveParserControlFlow_2_DoRemoveParserControlFlow
P4::TypeChecking_4_ResolveReferences
P4::TypeChecking_5_TypeInference
SimplifyControlFlow_4_TypeChecking
SimplifyControlFlow_5_DoSimplifyControlFlow
RemoveParserControlFlow_3_SimplifyControlFlow
FrontEnd_17_RemoveParserControlFlow
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
StructInitializers_0_TypeChecking
StructInitializers_1_CreateStructInitializers
StructInitializers_2_ClearTypeMap
FrontEnd_18_StructInitializers
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
SpecializeGenericFunctions_0_TypeChecking
SpecializeGenericFunctions_1_FindFunctionSpecializations
SpecializeGenericFunctions_2_SpecializeFunctions
FrontEnd_19_SpecializeGenericFunctions
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
TableKeyNames_0_TypeChecking
TableKeyNames_1_DoTableKeyNames
FrontEnd_20_TableKeyNames
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
ConstantFolding_0_TypeChecking
ConstantFolding_1_DoConstantFolding
ConstantFolding_2_ClearTypeMap
PassRepeated_0_ConstantFolding
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
P4::TypeChecking_2_ApplyTypesToExpressions
P4::TypeChecking_3_ResolveReferences
P4::StrengthReduction_0_TypeChecking
P4::StrengthReduction_1_StrengthReduction
PassRepeated_1_StrengthReduction
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
UselessCasts_0_TypeChecking
UselessCasts_1_RemoveUselessCasts
PassRepeated_2_UselessCasts
P4::TypeChecking_2_ResolveReferences
P4::TypeChecking_3_TypeInference
ConstantFolding_3_TypeChecking
ConstantFolding_4_DoConstantFolding
ConstantFolding_5_ClearTypeMap
PassRepeated_3_ConstantFolding
P4::TypeChecking_4_ResolveReferences
P4::TypeChecking_5_TypeInference
P4::TypeChecking_6_ApplyTypesToExpressions
P4::TypeChecking_7_ResolveReferences
P4::StrengthReduction_2_TypeChecking
P4::StrengthReduction_3_StrengthReduction
PassRepeated_4_StrengthReduction
P4::TypeChecking_2_ResolveReferences
P4::TypeChecking_3_TypeInference
UselessCasts_2_TypeChecking
UselessCasts_3_RemoveUselessCasts
PassRepeated_5_UselessCasts
FrontEnd_21_PassRepeated
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
SimplifyControlFlow_0_TypeChecking
SimplifyControlFlow_1_DoSimplifyControlFlow
FrontEnd_22_SimplifyControlFlow
FrontEnd_23_SwitchAddDefault
FrontEnd_24_FrontEndDump
PassRepeated_0_ResolveReferences
PassRepeated_1_RemoveUnusedDeclarations
PassRepeated_2_ResolveReferences
PassRepeated_3_RemoveUnusedDeclarations
PassRepeated_4_ResolveReferences
PassRepeated_5_RemoveUnusedDeclarations
RemoveAllUnusedDeclarations_0_PassRepeated
FrontEnd_25_RemoveAllUnusedDeclarations
SimplifyParsers_0_ResolveReferences
SimplifyParsers_1_DoSimplifyParsers
FrontEnd_26_SimplifyParsers
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
ResetHeaders_0_TypeChecking
ResetHeaders_1_DoResetHeaders
FrontEnd_27_ResetHeaders
UniqueNames_0_ResolveReferences
UniqueNames_1_FindSymbols
UniqueNames_2_RenameSymbols
FrontEnd_28_UniqueNames
FrontEnd_29_MoveDeclarations
FrontEnd_30_MoveInitializers
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
SideEffectOrdering_0_TypeChecking
SideEffectOrdering_1_DoSimplifyExpressions
FrontEnd_31_SideEffectOrdering
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
SetHeaders_0_TypeChecking
SetHeaders_1_DoSetHeaders
FrontEnd_32_SetHeaders
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
SimplifyControlFlow_0_TypeChecking
SimplifyControlFlow_1_DoSimplifyControlFlow
FrontEnd_33_SimplifyControlFlow
FrontEnd_34_MoveDeclarations
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
SimplifyDefUse_0_TypeChecking
SimplifyDefUse_1_DoSimplifyDefUse
FrontEnd_35_SimplifyDefUse
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
UniqueParameters_0_TypeChecking
UniqueParameters_1_(anonymous namespace)::FindActionCalls
UniqueParameters_2_FindParameters
UniqueParameters_3_RenameSymbols
UniqueParameters_4_ClearTypeMap
FrontEnd_36_UniqueParameters
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
SimplifyControlFlow_0_TypeChecking
SimplifyControlFlow_1_DoSimplifyControlFlow
FrontEnd_37_SimplifyControlFlow
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
ConstantFolding_0_TypeChecking
ConstantFolding_1_DoConstantFolding
ConstantFolding_2_ClearTypeMap
SpecializeAll_0_ConstantFolding
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
SpecializeAll_1_TypeChecking
SpecializeAll_2_FindSpecializations
SpecializeAll_3_Specialize
PassRepeated_0_ResolveReferences
PassRepeated_1_RemoveUnusedDeclarations
RemoveAllUnusedDeclarations_0_PassRepeated
SpecializeAll_4_RemoveAllUnusedDeclarations
FrontEnd_38_SpecializeAll
RemoveParserControlFlow_0_DoRemoveParserControlFlow
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
SimplifyControlFlow_0_TypeChecking
SimplifyControlFlow_1_DoSimplifyControlFlow
RemoveParserControlFlow_1_SimplifyControlFlow
FrontEnd_39_RemoveParserControlFlow
RemoveReturns_0_ResolveReferences
RemoveReturns_1_DoRemoveReturns
FrontEnd_40_RemoveReturns
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
RemoveDontcareArgs_0_TypeChecking
RemoveDontcareArgs_1_DontcareArgs
RemoveDontcareArgs_2_ClearTypeMap
FrontEnd_41_RemoveDontcareArgs
MoveConstructors_0_ResolveReferences
MoveConstructors_1_MoveConstructorsImpl
FrontEnd_42_MoveConstructors
PassRepeated_0_ResolveReferences
PassRepeated_1_RemoveUnusedDeclarations
RemoveAllUnusedDeclarations_0_PassRepeated
FrontEnd_43_RemoveAllUnusedDeclarations
FrontEnd_44_ClearTypeMap
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
P4::TypeChecking_1_TypeInference
EvaluatorPass_0_TypeChecking
EvaluatorPass_0_TypeChecking
EvaluatorPass_1_Evaluator
EvaluatorPass_1_Evaluator
FrontEnd_45_EvaluatorPass
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
P4::InlinePass_0_TypeChecking
P4::InlinePass_1_DiscoverInlining
P4::InlinePass_2_InlineDriver
PassRepeated_0_ResolveReferences
PassRepeated_1_RemoveUnusedDeclarations
RemoveAllUnusedDeclarations_0_PassRepeated
P4::InlinePass_3_RemoveAllUnusedDeclarations
P4::Inline_0_InlinePass
P4::TypeChecking_2_ResolveReferences
P4::TypeChecking_2_ResolveReferences
P4::TypeChecking_3_TypeInference
P4::TypeChecking_3_TypeInference
EvaluatorPass_2_TypeChecking
EvaluatorPass_2_TypeChecking
EvaluatorPass_3_Evaluator
EvaluatorPass_3_Evaluator
P4::Inline_1_EvaluatorPass
FrontEnd_46_Inline
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
InlineActions_0_TypeChecking
InlineActions_1_DiscoverActionsInlining
InlineActions_2_InlineDriver
PassRepeated_0_ResolveReferences
PassRepeated_1_RemoveUnusedDeclarations
RemoveAllUnusedDeclarations_0_PassRepeated
InlineActions_3_RemoveAllUnusedDeclarations
FrontEnd_47_InlineActions
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
InlineFunctions_0_TypeChecking
InlineFunctions_1_DiscoverFunctionsInlining
InlineFunctions_2_InlineDriver
PassRepeated_0_ResolveReferences
PassRepeated_1_RemoveUnusedDeclarations
RemoveAllUnusedDeclarations_0_PassRepeated
InlineFunctions_3_RemoveAllUnusedDeclarations
FrontEnd_48_InlineFunctions
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
CheckConstants_0_TypeChecking
CheckConstants_1_DoCheckConstants
FrontEnd_49_CheckConstants
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
SimplifyControlFlow_0_TypeChecking
SimplifyControlFlow_1_DoSimplifyControlFlow
FrontEnd_50_SimplifyControlFlow
RemoveParserControlFlow_0_DoRemoveParserControlFlow
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
SimplifyControlFlow_0_TypeChecking
SimplifyControlFlow_1_DoSimplifyControlFlow
RemoveParserControlFlow_1_SimplifyControlFlow
FrontEnd_51_RemoveParserControlFlow
UniqueNames_0_ResolveReferences
UniqueNames_1_FindSymbols
UniqueNames_2_RenameSymbols
FrontEnd_52_UniqueNames
LocalizeAllActions_0_TagGlobalActions
PassRepeated_0_ResolveReferences
PassRepeated_1_FindGlobalActionUses
PassRepeated_2_LocalizeActions
PassRepeated_3_ResolveReferences
PassRepeated_4_FindGlobalActionUses
PassRepeated_5_LocalizeActions
LocalizeAllActions_1_PassRepeated
LocalizeAllActions_2_ResolveReferences
LocalizeAllActions_3_FindRepeatedActionUses
LocalizeAllActions_4_DuplicateActions
PassRepeated_0_ResolveReferences
PassRepeated_1_RemoveUnusedDeclarations
PassRepeated_2_ResolveReferences
PassRepeated_3_RemoveUnusedDeclarations
RemoveAllUnusedDeclarations_0_PassRepeated
LocalizeAllActions_5_RemoveAllUnusedDeclarations
FrontEnd_53_LocalizeAllActions
UniqueNames_0_ResolveReferences
UniqueNames_1_FindSymbols
UniqueNames_2_RenameSymbols
FrontEnd_54_UniqueNames
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
UniqueParameters_0_TypeChecking
UniqueParameters_1_(anonymous namespace)::FindActionCalls
UniqueParameters_2_FindParameters
UniqueParameters_3_RenameSymbols
UniqueParameters_4_ClearTypeMap
FrontEnd_55_UniqueParameters
P4::TypeChecking_0_ResolveReferences
P4::TypeChecking_1_TypeInference
SimplifyControlFlow_0_TypeChecking
SimplifyControlFlow_1_DoSimplifyControlFlow
FrontEnd_56_SimplifyControlFlow
FrontEnd_57_HierarchicalNames
FrontEnd_58_FrontEndLast
BMV2::SimpleSwitchMidEnd_0_CheckTableSize
BMV2::SimpleSwitchMidEnd_1_RemoveMiss
BMV2::SimpleSwitchMidEnd_2_EliminateNewtype
BMV2::SimpleSwitchMidEnd_3_EliminateSerEnums
BMV2::SimpleSwitchMidEnd_4_RemoveActionParameters
BMV2::SimpleSwitchMidEnd_5_ConvertEnums
BMV2::SimpleSwitchMidEnd_6_VisitFunctor
BMV2::SimpleSwitchMidEnd_7_OrderArguments
BMV2::SimpleSwitchMidEnd_8_TypeChecking
BMV2::SimpleSwitchMidEnd_9_SimplifyKey
BMV2::SimpleSwitchMidEnd_10_ConstantFolding
BMV2::SimpleSwitchMidEnd_11_StrengthReduction
BMV2::SimpleSwitchMidEnd_12_SimplifySelectCases
BMV2::SimpleSwitchMidEnd_13_ExpandLookahead
BMV2::SimpleSwitchMidEnd_14_ExpandEmit
BMV2::SimpleSwitchMidEnd_15_SimplifyParsers
BMV2::SimpleSwitchMidEnd_16_StrengthReduction
BMV2::SimpleSwitchMidEnd_17_EliminateTuples
BMV2::SimpleSwitchMidEnd_18_SimplifyComparisons
BMV2::SimpleSwitchMidEnd_19_CopyStructures
BMV2::SimpleSwitchMidEnd_20_NestedStructs
BMV2::SimpleSwitchMidEnd_21_SimplifySelectList
BMV2::SimpleSwitchMidEnd_22_RemoveSelectBooleans
BMV2::SimpleSwitchMidEnd_23_FlattenHeaders
BMV2::SimpleSwitchMidEnd_24_FlattenInterfaceStructs
BMV2::SimpleSwitchMidEnd_25_ReplaceSelectRange
BMV2::SimpleSwitchMidEnd_26_Predication
BMV2::SimpleSwitchMidEnd_27_MoveDeclarations
BMV2::SimpleSwitchMidEnd_28_ConstantFolding
BMV2::SimpleSwitchMidEnd_29_LocalCopyPropagation
BMV2::SimpleSwitchMidEnd_30_ConstantFolding
BMV2::SimpleSwitchMidEnd_31_SimplifyKey
BMV2::SimpleSwitchMidEnd_32_MoveDeclarations
BMV2::SimpleSwitchMidEnd_33_ValidateTableProperties
BMV2::SimpleSwitchMidEnd_34_SimplifyControlFlow
BMV2::SimpleSwitchMidEnd_35_CompileTimeOperations
BMV2::SimpleSwitchMidEnd_36_TableHit
BMV2::SimpleSwitchMidEnd_37_RemoveLeftSlices
BMV2::SimpleSwitchMidEnd_38_TypeChecking
BMV2::SimpleSwitchMidEnd_39_MidEndLast
BMV2::SimpleSwitchMidEnd_40_EvaluatorPass
BMV2::SimpleSwitchMidEnd_41_VisitFunctor
PassManager_0_BMV2__ParseAnnotations
PassManager_1_RenameUserMetadata
PassManager_2_ClearTypeMap
PassManager_3_SynthesizeActions
PassManager_4_MoveActionsToTables
PassManager_5_TypeChecking
PassManager_6_SimplifyControlFlow
PassManager_7_LowerExpressions
PassManager_8_ConstantFolding
PassManager_9_TypeChecking
PassManager_10_RemoveComplexExpressions
PassManager_11_SimplifyControlFlow
PassManager_12_RemoveAllUnusedDeclarations
PassManager_13_ClonePathExpressions
PassManager_14_ClearTypeMap
PassManager_15_EvaluatorPass
PassManager_16_VisitFunctor
In file: /mnt/windows/Projekte/p4_tv/modules/p4c/backends/bmv2/common/expression.cpp:97
[31mCompiler Bug[0m: bugs/crash/empty_table_miss.p4.txt(37): dummy_table_0/dummy_table;: could not convert to Json
        if (dummy_table.apply().miss) {*/

#include <core.p4>
#include <v1model.p4>

header ethernet_t {
    bit<48> dst_addr;
    bit<48> src_addr;
    bit<16> eth_type;
}

struct Headers {
    ethernet_t eth_hdr;
}

struct Meta {
}

parser p(packet_in pkt, out Headers hdr, inout Meta m, inout standard_metadata_t sm) {
    state start {
        transition parse_hdrs;
    }
    state parse_hdrs {
        pkt.extract(hdr.eth_hdr);
        transition accept;
    }
}

control ingress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {

    table dummy_table {
        key = {
        }
        actions = {
        }
    }

    apply {
        if (dummy_table.apply().miss) {
            h.eth_hdr.eth_type = h.eth_hdr.eth_type;
        } else {
        }
    }
}

control vrfy(inout Headers h, inout Meta m) {
    apply {
    }
}

control update(inout Headers h, inout Meta m) {
    apply {
    }
}

control egress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    apply {
    }
}

control deparser(packet_out pkt, in Headers h) {
    apply {
        pkt.emit(h);
    }
}

V1Switch(p(), vrfy(), ingress(), egress(), update(), deparser()) main;

