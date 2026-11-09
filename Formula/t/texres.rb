class Texres < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/texres"
  url "https://github.com/leoliu0/texres/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "2740ada8d9cd7084a59880d35206206de0d8264b6e94d68ce2828e32261d76f5"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/texres.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "61f3e221782bea91f6cdf26ad3522a16b769fd8095739d3ceaf5c7f07d349814"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3a40208b1736d3e159345328f892a2816f54a340aae8353bbf563e42767de4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b7ee0238d4f0c128af31e99861597cc47d44e689bce57dca5af40c5f41c12cb"
    sha256 cellar: :any,                 arm64_linux:       "7ced096803896e3d62926941a2386e514eacd29843b225103e115e159c5d662b"
    sha256 cellar: :any,                 x86_64_linux:      "faf309a5d2598cea09fd7cb7e90ec04697f17b26225b1a8fa8ec6b415c33ed09"
  end

  depends_on "rust" => :build

  conflicts_with "texlive", because: "both install `lualatex`, `pdflatex`, `xelatex` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "texres", *std_cargo_args(path: "crates/tex-cli")
    %w[latexdiff lualatex pdflatex ratex tex-bibtex texmk xelatex].each { |cmd| bin.install_symlink "texres" => cmd }
  end

  test do
    (testpath/"sample.tex").write <<~'LATEX'
      \documentclass{article}

      \title{Test}
      \author{Homebrew}
      \date{\today}

      \begin{document}
        \maketitle

        \section{Example!}

        This is simple \LaTeX file.

      \end{document}
    LATEX

    system bin/"texres", testpath/"sample.tex"

    assert_path_exists testpath/"sample.pdf"
  end
end
