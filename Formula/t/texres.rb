class Texres < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/texres"
  url "https://github.com/leoliu0/texres/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "0b75a630c18a0d62ad42e90328bb223d2389eb29e6dfdefee94089872f6e36ce"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/texres.git", branch: "main"

  bottle do
    manifest_sha256 "858c894af5cd137a4d6e45b784ca7cbafb76f9644ae01ed7168388fda93e63f3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cae14343fae3d639555ab2dda23012c9645800bee1be60c19095af77cb32e4e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fedc76832f77226a6894b003995432253de2a1e0c6589df8be80e37766e92dbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "643c3b9b6e9cbc8ec2a606f1fbbf59d38e4dbaeab934887c7085d4d13184ceb2"
    sha256 cellar: :any,                 arm64_linux:       "d4b861ab6555645bc7b55ec4cca0c0d3e6f6d2b331ae3627d7b1bf1020f00ff8"
    sha256 cellar: :any,                 x86_64_linux:      "955eaafea6276542aec656111b66f65f9941a34e7151201362322d6ff813eec7"
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
