class Texres < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/texres"
  url "https://github.com/leoliu0/texres/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "71f68c25de5d76f45264f088779799e3753561e875acec4203ca085ecf5a9e54"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/texres.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c6ece29a529c2dc20e8feee8aaca87a81eb1a708d9e11d7f35c8107c2349bc14"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06473ecf40ede932737b994724b2b1025952711a4dfc90727e83ee4dcb4bba5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1182163d0b2ddccd5ccd051c45df9631ae44c11e79c03312b8c993e301527d0f"
    sha256 cellar: :any,                 arm64_linux:       "ca2c406701188982e4a10dcf18d5ca022b3b4b4588620841878f516a967b470a"
    sha256 cellar: :any,                 x86_64_linux:      "44474b160dbb5dba4e9dfe796802596ce602dcf2da60017f276e6d5c8e8c762b"
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
