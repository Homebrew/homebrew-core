class Skylighting < Formula
  desc "Flexible syntax highlighter using KDE XML syntax descriptions"
  homepage "https://github.com/jgm/skylighting"
  url "https://hackage.haskell.org/package/skylighting-0.14.7/skylighting-0.14.7.tar.gz"
  sha256 "05df6bce0aba5af7da7b618e1891cbe02833f6810b2405e96c254e9ff741001f"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b066831cc90c359d24098a93b5aec85b8a267c239dc875c0a8b86ab00f2946c4"
    sha256 cellar: :any,                 arm64_sequoia: "d9ca80d6ddb43d1fcbe8a0372f9f71f03da811c7b5f21c713ec3057fc8414d5b"
    sha256 cellar: :any,                 arm64_sonoma:  "84ff771c5a005c402cdf4149720a61e3ef1b8717a0beb1f2bf28fcfacb378f37"
    sha256 cellar: :any,                 sonoma:        "8856a01dc2e3b17fd9bf22b1f47f68186a3319d581359b9c55704ca79951ac1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4b189d8e4e132045077b391ff6fbf4095d2147764ebb47f047a609d72ae9793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0abc7e9b039fd54255d4a640609ac7d9568d98fff976ade5f8563d631d52cb82"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", "--flags=executable", *args, *std_cabal_v2_args
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
