class Texres < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/texres"
  url "https://github.com/leoliu0/texres/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "8505a07e31ae4ab9277e39c83fb1a0be862dc8f1c787a77cc22d86b93dfd32f9"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/texres.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b539e1a7967ff6e30901b7d2d6b6fd59756cd4c1a3aa2d1ba59f1d35597fedc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "228251401677eda20ef2d7f93f4c05b936307ea0a8727774015602e8a2406e73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26d2a7c857c14508f0e4f88580ffb02542e4aa636d6f3f03c36440df335fdc1e"
    sha256 cellar: :any,                 arm64_linux:       "6723176c758332be40fd79247569b6441730e144521e78c3db4ecd8928a26b91"
    sha256 cellar: :any,                 x86_64_linux:      "19e090c3f6f4432b75a7b496b288407ecacc014a09b82c1ad738b28005d75205"
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
