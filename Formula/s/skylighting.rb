class Skylighting < Formula
  desc "Flexible syntax highlighter using KDE XML syntax descriptions"
  homepage "https://github.com/jgm/skylighting"
  url "https://hackage.haskell.org/package/skylighting-0.15.0.1/skylighting-0.15.0.1.tar.gz"
  sha256 "b84691c7e2e619e0f98e28a3f468bb7a57c68293efe9d6c66174f4123b8d570e"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "847411e10873ad306943ebb698367e3c01863c6e4521589570235ae51812412f"
    sha256 cellar: :any, arm64_tahoe:       "97e2362843abfeace57c206c68ebd59168773a8c15042576a79a715b32b2775e"
    sha256 cellar: :any, arm64_sequoia:     "a07712f08675e94a754cc5976657defb1f9e25b7b35fd6605faa09e94b9b5863"
    sha256 cellar: :any, arm64_linux:       "369c3bde6095b16362e962bfbe1dac42e84342a01241bafb13914e7495a30ad6"
    sha256 cellar: :any, x86_64_linux:      "a48c29d01158b15072e3a73c6e88c97d6e726e9afa3c50d4c0ca8a20ca0efe32"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--only-download", "--flags=executable", *std_cabal_v2_args
  end

  def install
    system "cabal", "v2-install", "--flags=executable", *std_cabal_v2_args
  end

  test do
    (testpath/"Test.java").write <<~JAVA
      import java.util.*;

      public class Test {
          public static void main(String[] args) throws Exception {
              final ArrayDeque<String> argDeque = new ArrayDeque<>(Arrays.asList(args));
              for (arg in argDeque) {
                  System.out.println(arg);
                  if (arg.equals("foo"))
                      throw new NoSuchElementException();
              }
          }
      }
    JAVA
    expected_out = <<~'LATEX'
      \documentclass{article}
      \usepackage[margin=1in]{geometry}
      \usepackage{color}
      \usepackage{fancyvrb}
      \newcommand{\VerbBar}{|}
      \newcommand{\VERB}{\Verb[commandchars=\\\{\}]}
      \DefineVerbatimEnvironment{Highlighting}{Verbatim}{commandchars=\\\{\}}
      % Add ',fontsize=\small' for more characters per line
      \usepackage{framed}
      \definecolor{shadecolor}{RGB}{255,255,255}
      \newenvironment{Shaded}{\begin{snugshade}}{\end{snugshade}}
      \newcommand{\AlertTok}[1]{\textcolor[rgb]{0.75,0.01,0.01}{\textbf{\colorbox[rgb]{0.97,0.90,0.90}{#1}}}}
      \newcommand{\AnnotationTok}[1]{\textcolor[rgb]{0.79,0.38,0.79}{#1}}
      \newcommand{\AttributeTok}[1]{\textcolor[rgb]{0.00,0.34,0.68}{#1}}
      \newcommand{\BaseNTok}[1]{\textcolor[rgb]{0.69,0.50,0.00}{#1}}
      \newcommand{\BuiltInTok}[1]{\textcolor[rgb]{0.39,0.29,0.61}{\textbf{#1}}}
      \newcommand{\CharTok}[1]{\textcolor[rgb]{0.57,0.30,0.62}{#1}}
      \newcommand{\CommentTok}[1]{\textcolor[rgb]{0.54,0.53,0.53}{#1}}
      \newcommand{\CommentVarTok}[1]{\textcolor[rgb]{0.00,0.58,1.00}{#1}}
      \newcommand{\ConstantTok}[1]{\textcolor[rgb]{0.67,0.33,0.00}{#1}}
      \newcommand{\ControlFlowTok}[1]{\textcolor[rgb]{0.12,0.11,0.11}{\textbf{#1}}}
      \newcommand{\DataTypeTok}[1]{\textcolor[rgb]{0.00,0.34,0.68}{#1}}
      \newcommand{\DecValTok}[1]{\textcolor[rgb]{0.69,0.50,0.00}{#1}}
      \newcommand{\DocumentationTok}[1]{\textcolor[rgb]{0.38,0.47,0.50}{#1}}
      \newcommand{\ErrorTok}[1]{\textcolor[rgb]{0.75,0.01,0.01}{\underline{#1}}}
      \newcommand{\ExtensionTok}[1]{\textcolor[rgb]{0.00,0.58,1.00}{\textbf{#1}}}
      \newcommand{\FloatTok}[1]{\textcolor[rgb]{0.69,0.50,0.00}{#1}}
      \newcommand{\FunctionTok}[1]{\textcolor[rgb]{0.39,0.29,0.61}{#1}}
      \newcommand{\ImportTok}[1]{\textcolor[rgb]{1.00,0.33,0.00}{#1}}
      \newcommand{\InformationTok}[1]{\textcolor[rgb]{0.69,0.50,0.00}{#1}}
      \newcommand{\KeywordTok}[1]{\textcolor[rgb]{0.12,0.11,0.11}{\textbf{#1}}}
      \newcommand{\NormalTok}[1]{\textcolor[rgb]{0.12,0.11,0.11}{#1}}
      \newcommand{\OperatorTok}[1]{\textcolor[rgb]{0.12,0.11,0.11}{#1}}
      \newcommand{\OtherTok}[1]{\textcolor[rgb]{0.00,0.43,0.16}{#1}}
      \newcommand{\PreprocessorTok}[1]{\textcolor[rgb]{0.00,0.43,0.16}{#1}}
      \newcommand{\RegionMarkerTok}[1]{\textcolor[rgb]{0.00,0.34,0.68}{\colorbox[rgb]{0.88,0.91,0.97}{#1}}}
      \newcommand{\SpecialCharTok}[1]{\textcolor[rgb]{0.24,0.68,0.91}{#1}}
      \newcommand{\SpecialStringTok}[1]{\textcolor[rgb]{1.00,0.33,0.00}{#1}}
      \newcommand{\StringTok}[1]{\textcolor[rgb]{0.75,0.01,0.01}{#1}}
      \newcommand{\VariableTok}[1]{\textcolor[rgb]{0.00,0.34,0.68}{#1}}
      \newcommand{\VerbatimStringTok}[1]{\textcolor[rgb]{0.75,0.01,0.01}{#1}}
      \newcommand{\WarningTok}[1]{\textcolor[rgb]{0.75,0.01,0.01}{#1}}
      \title{Test.java}

      \begin{document}
      \maketitle
      \begin{Shaded}
      \begin{Highlighting}[]
      \KeywordTok{import} \ImportTok{java}\OperatorTok{.}\ImportTok{util}\OperatorTok{.*;}

      \KeywordTok{public} \KeywordTok{class}\NormalTok{ Test }\OperatorTok{\{}
          \KeywordTok{public} \DataTypeTok{static} \DataTypeTok{void} \FunctionTok{main}\OperatorTok{(}\BuiltInTok{String}\OperatorTok{[]}\NormalTok{ args}\OperatorTok{)} \KeywordTok{throws} \BuiltInTok{Exception} \OperatorTok{\{}
              \DataTypeTok{final} \BuiltInTok{ArrayDeque}\OperatorTok{\textless{}}\BuiltInTok{String}\OperatorTok{\textgreater{}}\NormalTok{ argDeque }\OperatorTok{=} \KeywordTok{new} \BuiltInTok{ArrayDeque}\OperatorTok{\textless{}\textgreater{}(}\BuiltInTok{Arrays}\OperatorTok{.}\FunctionTok{asList}\OperatorTok{(}\NormalTok{args}\OperatorTok{));}
              \ControlFlowTok{for} \OperatorTok{(}\NormalTok{arg in argDeque}\OperatorTok{)} \OperatorTok{\{}
                  \BuiltInTok{System}\OperatorTok{.}\FunctionTok{out}\OperatorTok{.}\FunctionTok{println}\OperatorTok{(}\NormalTok{arg}\OperatorTok{);}
                  \ControlFlowTok{if} \OperatorTok{(}\NormalTok{arg}\OperatorTok{.}\FunctionTok{equals}\OperatorTok{(}\StringTok{"foo"}\OperatorTok{))}
                      \ControlFlowTok{throw} \KeywordTok{new} \BuiltInTok{NoSuchElementException}\OperatorTok{();}
              \OperatorTok{\}}
          \OperatorTok{\}}
      \OperatorTok{\}}
      \end{Highlighting}
      \end{Shaded}

      \end{document}
    LATEX

    assert_equal expected_out.strip, shell_output("#{bin}/skylighting -f latex Test.java").strip
  end
end
