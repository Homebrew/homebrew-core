class Skylighting < Formula
  desc "Flexible syntax highlighter using KDE XML syntax descriptions"
  homepage "https://github.com/jgm/skylighting"
  url "https://hackage.haskell.org/package/skylighting-0.15/skylighting-0.15.tar.gz"
  sha256 "2929c28a042453ee67785201dda234308ef19e068fb474cc1db69dd5f67c4dab"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a37b774907c122728226b0b35e3d762dc7353b6935bdc3b960e112d28ebcffe6"
    sha256 cellar: :any, arm64_tahoe:       "4c3fa2611a6f4069f850943622ce507aa06598b79492f8e8276c0386d836d9e6"
    sha256 cellar: :any, arm64_sequoia:     "e6fd10b2a8c031cbd3d2fa40f0e6baf99eeb677c280ba956d6d615a8f3c57773"
    sha256 cellar: :any, arm64_linux:       "074da3fb40d1647c0504b50dead72fba5735f8732fca3b5231e423b66f069b89"
    sha256 cellar: :any, x86_64_linux:      "bd01fc200102922d4923cbc5f249ad86497cc98aeb1adc37d9e66679ece8aa10"
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
