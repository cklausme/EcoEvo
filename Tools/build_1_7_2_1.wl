(* Build the frozen 1.7.2.1 payload prepared by prepare_1_7_2_1.py.
   This creates an archive under build/; it does not install or publish it. *)
Module[{root, stage, manifest, names, paths, actual, invalid, sourceExpressions, stageExpressions, archive},
  root = DirectoryName[DirectoryName[$InputFileName]];
  stage = FileNameJoin[{root, "build", "1.7.2.1", "EcoEvo-1.7.2.1"}];
  manifest = Import[FileNameJoin[{root, "Release", "1.7.2.1", "payload-sha256.json"}], "RawJSON"];
  names = Keys[manifest["files"]];
  paths = FileNameJoin[Prepend[StringSplit[#, "/"], stage]] & /@ names;
  actual = Select[FileNames["*", stage, Infinity], FileType[#] === File &];
  If[Sort[actual] =!= Sort[paths],
    Return[Failure["PayloadFiles", <|"MessageTemplate" -> "Run Tools/prepare_1_7_2_1.py first; stage files must match the release manifest."|>]]];
  invalid = Select[Transpose[{names, paths}],
    FileHash[#[[2]], "SHA256", "HexString"] =!= manifest["files"][#[[1]]] &];
  If[invalid =!= {}, Return[Failure["PayloadHash", <|"Files" -> invalid[[All, 1]]|>]]];
  sourceExpressions = Block[{$Context = "EcoEvoBuildSourceCheck`", $ContextPath = {"System`"}},
    ReadList[FileNameJoin[{root, "EcoEvo", "EcoEvo.m"}], Hold[Expression]]];
  stageExpressions = Block[{$Context = "EcoEvoBuildSourceCheck`", $ContextPath = {"System`"}},
    ReadList[FileNameJoin[{stage, "EcoEvo", "EcoEvo.m"}], Hold[Expression]]];
  If[MemberQ[sourceExpressions, $Failed] || MemberQ[stageExpressions, $Failed] ||
      DeleteCases[sourceExpressions, Hold[Null]] =!= DeleteCases[stageExpressions, Hold[Null]],
    Return[Failure["SourceMismatch", <|"MessageTemplate" -> "The editable runtime differs from the frozen tested code. Update the patch and manifest for a new build."|>]]];
  Needs["PacletManager`"];
  archive = PacletManager`PackPaclet[stage];
  <|"Archive" -> archive, "PayloadFilesVerified" -> Length[names],
    "ArchiveSHA256" -> FileHash[archive, "SHA256", "HexString"],
    "OriginalTestedArchiveSHA256" -> manifest["tested_archive_sha256"]|>
]
