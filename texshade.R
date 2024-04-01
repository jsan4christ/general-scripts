library(msa)
library(tools)
library(Biostrings)
library(seqinr)
library(bioseq)
library(knitr)
library(tinytex)

## where is texshade.sty located?
system.file("tex", "texshade.sty", package = "msa")

## load msa
alignment_aa <- readAAStringSet("MON26022024/Tree_nucleotide_sequences_for_20PIDs_sj_0_aa.fas")
alignment_aa_aln <- msa(alignment_aa, order="input")

print(alignment_aa_aln, show="complete")

## show resulting LaTeX code with default settings
msaPrettyPrint(alignment_aa_aln, output="asis", askForOverwrite=FALSE)

## create PDF file according to some custom settings
## Not run: 
# tmpFile <- tempfile(pattern="msa", tmpdir=".", fileext=".pdf")
# tmpFile
msaPrettyPrint(alignment_aa_aln, output="pdf",
               showNames="left", showNumbering="none", showLogo="top",
               showConsensus="none", 
               verbose=FALSE, askForOverwrite=FALSE, furtherCode=c("\\defconsensus{.}{lower}{upper}",
                                                                   "\\showruler{bottom}{1}",
                                                                   "\\setdomain{1}{2..61}",
                                                                   "\\featureslarge",
                                                                   "\\shadingmode{diverse}{tat-consensus-c }" ,
                                                                   "\\threshold{50}",
                                                                   "\\feature{ttop}{1}{1..61}{bar:conservation}{}",
                                                                   "\\showfeaturestylename{ttop}{conserv.}",
                                                                   "\\bargraphstretch{3}",
                                                                   "\\ttopspace{1mm}"
                                                                   )
               )


### version 2
msaPrettyPrint(alignment_aa_aln, output="pdf",
               showNames="left", showNumbering="none", showLogo="top",
               showConsensus="none", 
               verbose=FALSE, askForOverwrite=FALSE, furtherCode=c("\\defconsensus{.}{lower}{upper}",
                                                                   "\\showruler{bottom}{1}",
                                                                   "\\setdomain{1}{2..61}",
                                                                   "\\featureslarge",
                                                                   "\\shadingmode[allmatchspecial]{similar}{diverse}{tat-consensus-c }" ,
                                                                   "\\threshold[80]{50}",
                                                                   "\\feature{ttop}{1}{1..61}{bar:conservation}{}",
                                                                   "\\showfeaturestylename{ttop}{conserv.}",
                                                                   "\\bargraphstretch{3}",
                                                                   "\\ttopspace{1mm}",
                                                                   "\\showlogoscale{left}"
               )
)


# msaPrettyPrint(alignment_aa_aln, output="pdf",
#                showNames="left", showNumbering="none", showLogo="top",
#                showConsensus="none", logoColors="standard area",
#                verbose=FALSE, askForOverwrite=FALSE, furtherCode=c("\\defconsensus{.}{lower}{upper}",
#                                                                    "\\setends{1}{1..61}",
#                                                                    "\feature{ttop}{1}{1..61}{bar:conservation}{}",
#                                                                    "\\showfeaturestylename{ttop}{conserv.}",
#                                                                    "\\showruler{1}{bottom}",
#                                                                    "\\orderseqs{3,1-2,4-39}",
#                                                                    "\\setdomain{1}{2..61}",
#                                                                    "\\shadingmode{tat-consensus-C }{diverse}"                                                                   )
# )

