class Texres < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/texres"
  url "https://github.com/leoliu0/texres/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "8505a07e31ae4ab9277e39c83fb1a0be862dc8f1c787a77cc22d86b93dfd32f9"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/texres.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb2e7fd2832340b6a8d9d2e8c7b4d7bb65e0b8c3a3a81f79ce9b3cf8c855166b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "60f8230347e6182dbe4b3015601e091d8037389afe45d0f3af74d187ae6a71a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6e0386e537af17d190562b60fa73b893d862cb65b27472f43c58bbc5904ab33"
    sha256 cellar: :any,                 arm64_linux:       "7ef6652f57a85e00a535ee53a9166a3181bab5bd416058449e4664f228f7ddfb"
    sha256 cellar: :any,                 x86_64_linux:      "24a9c2b6e922255a7a65505e2d1c7ced2c815de41717b34c11ece92506d88430"
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
