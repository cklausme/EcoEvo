(* ::Package:: *)

package="EcoEvo";
version="1.0.2"


(* Mathematica Source File  *)
(* Created by Mathematica Plugin for IntelliJ IDEA *)
(* :Author: szhorvat *)
(* :Date: 2016-11-28 *)

(* Modified by C. Klausmeier 9/13/2019 for EcoEvo package *)

(* Run this script optionally for minor improvements to the built documentation.
   Requires PackageTools, https://github.com/szhorvat/PackageTools
*)

AddPath["PackageTools"]
Needs["PackageTools`"]

SetDirectory@NotebookDirectory[];

$docDir = FileNameJoin[{"build", package<>"-"<>version, package,"Documentation"}];
Print[$docDir];
If[Not@DirectoryQ[$docDir],
  Print["Documentation directory not found.  Aborting."];
  Abort[]
]

code =
    With[{$docDir = $docDir, package = package},
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


PacletUninstall[package]


rootdir=NotebookDirectory[]


sourcedir=FileNameJoin[{rootdir,package}]


builddir=FileNameJoin[{rootdir,"build",package<>"-"<>version,package}]


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