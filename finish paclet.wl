(* ::Package:: *)

(* ::Section:: *)
(*directories*)


package="EcoEvo";
version="1.1.0";


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


(* ::Section::Closed:: *)
(*cloud docs*)


CopyDirectory[FileNameJoin[{docdir,"English"}],FileNameJoin[{builddir,"CloudDocs"}]];
clouddocdir=FileNameJoin[{builddir,"CloudDocs"}]


DeleteDirectory[FileNameJoin[{clouddocdir,"Index"}],DeleteContents->True];
DeleteDirectory[FileNameJoin[{clouddocdir,"SpellIndex"}],DeleteContents->True];


NBFixURLs[nb_]:=
ReplaceAll[
      nb,
      Unevaluated[Documentation`HelpLookup[str_String]] :> Hyperlink[
      StringReplace[str,"paclet:"->"https://www.wolframcloud.com/obj/EcoEvo/Published/"]<>".nb"]
    ]


NBKillURLs[nb_]:=
NotebookDelete[Cells[CellTags->"MyCell"]
    ]


echo = (Print[#];#)&;
FileNames["*.nb",clouddocdir,Infinity] //
	Scan[
		echo /*
		RewriteNotebook[
			NBSetOptions[{DockedCells->{}}] /*
			NBFixURLs			
		]
	]


CopyDirectory[
	clouddocdir,
	CloudObject["Published/EcoEvo"]
]
