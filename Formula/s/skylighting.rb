class Skylighting < Formula
  desc "Flexible syntax highlighter using KDE XML syntax descriptions"
  homepage "https://github.com/jgm/skylighting"
  url "https://hackage.haskell.org/package/skylighting-0.14.7/skylighting-0.14.7.tar.gz"
  sha256 "05df6bce0aba5af7da7b618e1891cbe02833f6810b2405e96c254e9ff741001f"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "1bbb4046dcfe86e9cbcc19b6a207971ce2761c76733ee1263f3c3dd01c21436f"
    sha256 cellar: :any, arm64_sequoia: "730ee7c866b559c734d4689c93259fdd9bdfe67fe5751c6389433456de3ec8ec"
    sha256 cellar: :any, arm64_sonoma:  "5821b83e41fb31bc686e464b4497e6e14d90fad0c89998454c476545adc9803c"
    sha256 cellar: :any, sonoma:        "07b1958368cac8aa092bb0bbd9c90de1c45b68df4cb4e602e90776e9b21859e6"
    sha256 cellar: :any, arm64_linux:   "0e25564beb472c975d8e95f936019aff80708b9e261b9eb53b7197623af0ac82"
    sha256 cellar: :any, x86_64_linux:  "84ba245e9a1f3df0cf208202f68e84710112620125255fc2ba37a6381c8c784d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cabal", "v2-update"
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
