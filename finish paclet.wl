(* ::Package:: *)

(* ::Section:: *)
(*directories*)


package="EcoEvo";
version="1.6.2";


Needs["PackageTools`"]


PacletUninstall[package]


rootdir=SetDirectory@NotebookDirectory[]


sourcedir=FileNameJoin[{rootdir,package}]


RenameDirectory[FileNameJoin[{rootdir,"build",package}],FileNameJoin[{rootdir,"build",package<>"-"<>version}]]


builddir=FileNameJoin[{rootdir,"build",package<>"-"<>version,package}]


docdir=FileNameJoin[{builddir, "Documentation"}]


(* ::Section:: *)
(*fix docs*)


code =
    With[{$docDir = docdir, package = package},
      MCode[
        echo = (Print[#];#)&;
        FileNames["*.nb", $docDir, Infinity] //
          Scan[
            echo /*
            RewriteNotebook[
              NBHideInput /*
              NBRemoveURL /*
              (* NBDeleteCellTags["HideInput"] /* *)
              NBSetOptions[Saveable -> False] /*
              NBRemoveChangeTimes /*
              NBResetWindow /*
              Function[nb,
                Replace[nb, sd : HoldPattern[StyleDefinitions -> Except[_Notebook]] :>
                    StyleDefinitions -> Notebook[{Cell@StyleData[sd]}],
                  {1}
                ]
              ] /*
              Function[nb,
                Replace[nb,
                  HoldPattern[StyleDefinitions -> Notebook[{cells___}, rest___]] :>
                    (StyleDefinitions -> Notebook[
                      {
                      cells,
                      Cell[StyleData[#], ShowGroupOpener -> True]& /@ Unevaluated@Sequence["NotesSection", "PrimaryExamplesSection", "ExampleSection", "ExampleSubsection"],
                      Cell[StyleData["GuideTutorialsSection", StyleDefinitions -> StyleData["SeeAlsoSection"]]]
                      }, rest]),
                  {1}
                ]
              ] /*
              Function[nb,
                Replace[nb,
                  (BaseStyle->{"InlineFormula", FontFamily -> "Verdana"}) ->
                      (BaseStyle -> FEPrivate`If[
                        FEPrivate`Less[ FEPrivate`$VersionNumber, 11.1],
                        {"InlineFormula", FontFamily -> "Verdana"},
                        {"InlineFormula"}
                      ]),
                  Infinity
                ]
              ]
            ]
          ]
      ]
    ];

(* Process in version 10.0 to avoid InsufficientVersionWarning *)
MRun[code, "10.0"]


(* ::Section:: *)
(*make paclet*)


CopyDirectory[FileNameJoin[{sourcedir,"Kernel"}],FileNameJoin[{builddir,"Kernel"}]]


CopyFile[FileNameJoin[{sourcedir,package<>".m"}],FileNameJoin[{builddir,package<>".m"}],OverwriteTarget->True]
CopyFile[FileNameJoin[{sourcedir,"Logo.png"}],FileNameJoin[{builddir,"Logo.png"}],OverwriteTarget->True]
CopyFile[FileNameJoin[{rootdir,"LICENSE.txt"}],FileNameJoin[{builddir,"LICENSE.txt"}],OverwriteTarget->True]


(*SetDirectory@FileNameJoin[{sourcedir, "Documentation", "English"}];
MRun[
  MCode[
    Needs["DocumentationSearch`"];
    DocumentationSearch`CreateDocumentationIndex[Directory[], Directory[], "TextSearchIndex", "UseWolframLanguageData" -> False];
  ],
  "11.2"
]
ResetDirectory[];*)


SetDirectory[builddir]


paclet=PackPaclet[FileNameJoin[{rootdir,"build","EcoEvo-"<>version}]]


PacletInstall[paclet]


(* ::Section:: *)
(*update pacletsite (run after moving paclet from build to Paclets, then commit & push)*)


<<PacletManager`


PacletManager`BuildPacletSiteFiles["/Users/klaus/github/EcoEvo"]


(* ::Section:: *)
(*cloud docs*)


pacletName="EcoEvo";


(* mostly by Jan P\[ODoubleDot]schko <https://mathematica.stackexchange.com/a/207632/6358> *)


(*dirPrefixes=<|"Guides"->"guide","Tutorials"->"tutorial",{"ReferencePages","Symbols"}->"ref"|>;

subdirString[prefix_String]:=prefix
subdirString[prefixes_List]:=FileNameJoin[prefixes]

pacletLinkQ[str_String]:=StringStartsQ[str,"paclet:"]
pacletLinkQ[_]:=False

fixPacletLink[str_,pacletName_,targetURL_]:=StringReplace[str,(StartOfString~~"paclet:"~~pacletName)->targetURL]<>".nb"

(*fixPacletLinks[nb_Notebook,pacletName_,targetDir_String]:=nb/.ButtonBox[content_,opts1___,ButtonData\[Rule]data_?pacletLinkQ,opts2___]\[RuleDelayed]ButtonBox[content,ButtonFunction\[RuleDelayed](FrontEndExecute[NotebookLocate[{URL[#2],None}]]&),opts1,ButtonData\[Rule]fixPacletLink[data,pacletName,targetDir],opts2]*)

fixPacletLinks[nb_Notebook,pacletName_,targetDir_String]:=
nb/.TemplateBox[{content_,data_?pacletLinkQ},"RefLink",opts___]:>TemplateBox[{content,fixPacletLink[data,pacletName,targetDir]},"WebLink",opts]/.ButtonBox[content_,opts1___,ButtonData->data_?pacletLinkQ,opts2___]:>ButtonBox[content,ButtonFunction:>(FrontEndExecute[NotebookLocate[{URL[#2],None}]]&),opts1,ButtonData->fixPacletLink[data,pacletName,targetDir],opts2];

removeDockedCells[Notebook[content_,opts1___,DockedCells->_,opts2___]]:=Notebook[content,opts1,DockedCells->{},opts2]
removeDockedCells[Notebook[content_,opts___]]:=Notebook[content,DockedCells->{},opts]

resetMagnification[Notebook[content_,opts1___,(Rule|RuleDelayed)[Magnification,_],opts2___]]:=Notebook[content,opts1,opts2]
resetMagnification[nb_Notebook]:=nb

fixStyleSheet[Notebook[content_,opts1___,StyleDefinitions->_,opts2___]]:=Notebook[content,opts1,StyleDefinitions->FrontEnd`FileName[{"Wolfram"},"Reference.nb"],opts2]

removePulldownMenus[Notebook[content_,opts___]]:=Notebook[content[[2;;]],opts];

publishDocNB[filename_String,target:CloudObject[targetURL_,___],prefix_,pacletName_]:=Module[{nb,newNB,obj},nb=Get[filename];
newNB=resetMagnification@removePulldownMenus@(*fixStyleSheet@*)removeDockedCells@fixPacletLinks[nb,pacletName,targetURL];
obj=FileNameJoin[{target,prefix,FileNameTake[filename]}];
Print["Publishing ",filename," to ",obj];
(*NotebookSave[newNB,"test.nb"];*)
CloudPublish[newNB,obj]]

publishDocDir[pacletDir_,subdir_,prefix_,target_]:=Module[{nbfiles=FileNames["*.nb",FileNameJoin[{pacletDir,"Documentation","English",subdirString[subdir]}]],pacletName=FileNameTake[pacletDir]},publishDocNB[#,target,prefix,pacletName]&/@nbfiles]

PublishPacletDocs[pacletDir_String,target_CloudObject]:=KeyValueMap[publishDocDir[pacletDir,#1,#2,target]&,dirPrefixes]*)


dirPrefixes=<|"Guides"->"guide","Tutorials"->"tutorial",{"ReferencePages","Symbols"}->"ref"|>;

subdirString[prefix_String]:=prefix
subdirString[prefixes_List]:=FileNameJoin[prefixes]

pacletLinkQ[str_String]:=StringStartsQ[str,"paclet:"<>pacletName]
pacletLinkQ[_]:=False

fixPacletLink[str_,targetURL_]:=StringReplace[str,(StartOfString~~"paclet:"<>pacletName)->targetURL]<>".nb"

fixPacletLinks[nb_Notebook,targetDir_String]:=
nb/.{
TemplateBox[{content_,data_?pacletLinkQ},"RefLink",opts___]:>TemplateBox[{content,fixPacletLink[data,targetDir]},"WebLink",
DisplayFunction :> (TagBox[ButtonBox[StyleBox[#, FontColor -> RGBColor[0.054902, 0.243137, 0.72549]], ButtonData -> {URL[#2], None}], MouseAppearanceTag["LinkHand"]] &),opts],
ButtonBox[content_,opts1___,ButtonData->data_?pacletLinkQ,opts2___]:>ButtonBox[content,ButtonFunction:>(FrontEndExecute[NotebookLocate[{URL[#2],None}]]&),opts1,ButtonData->fixPacletLink[data,targetDir],opts2]
};

removeDockedCells[Notebook[content_,opts1___,DockedCells->_,opts2___]]:=Notebook[content,opts1,DockedCells->{},opts2]
removeDockedCells[Notebook[content_,opts___]]:=Notebook[content,DockedCells->{},opts]

resetMagnification[Notebook[content_,opts1___,(Rule|RuleDelayed)[Magnification,_],opts2___]]:=Notebook[content,opts1,opts2]
resetMagnification[nb_Notebook]:=nb

removePulldownMenus[Notebook[content_,opts___]]:=Notebook[content[[2;;]],opts];

publishDocNB[filename_String,target:CloudObject[targetURL_,___],prefix_,pacletName_]:=Module[{nb,newNB,obj},
	nb=Get[filename];
	Print[filename];
	newNB=resetMagnification@removePulldownMenus@removeDockedCells@fixPacletLinks[nb,targetURL];
	obj=FileNameJoin[{target,prefix,FileNameTake[filename]}];
	Print["Publishing ",filename," to ",obj];
	CloudPublish[newNB,obj]
]

publishDocDir[pacletDir_,subdir_,prefix_,target_]:=Module[{
	nbfiles=FileNames["*.nb",FileNameJoin[{pacletDir,"Documentation","English",subdirString[subdir]}]],
	pacletName=FileNameTake[pacletDir]},
	publishDocNB[#,target,prefix,pacletName]&/@nbfiles
]

PublishPacletDocs[pacletDir_String,target_CloudObject]:=KeyValueMap[publishDocDir[pacletDir,#1,#2,target]&,dirPrefixes]


PublishPacletDocs["~/github/EcoEvo/archive/EcoEvo-1.6.1/EcoEvo",CloudObject["docs"]];



