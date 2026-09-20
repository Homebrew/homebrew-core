class Ratex < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/ratex"
  url "https://github.com/leoliu0/ratex/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "b1b3cda82a19fddfceaabfeb45e9f61aedfb26d55fca58b87dd91e38e5ec2b3b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/ratex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7b2d8c976913f8ca888ed19bc4ba86e6e1179b9eb8957d01ef29e9e0dbc7710"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6d4fe546fd25a0d2174486198febb3dfd32ba3a3b76e88b0030e4728e905b87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4f8f44c00968d33e3276e57fc41f1f89c2ec8455212b2b8fe5f4a94d3d6d498"
    sha256 cellar: :any,                 arm64_linux:       "8434a5d8598f9b2102da2b7907d051618403fc75489f1c1c95ee3ed6fbcf6a41"
    sha256 cellar: :any,                 x86_64_linux:      "00561ee86e8259cc814d290aedbedfb59bde351865dc19d092ed09da2faaf76c"
  end

  depends_on "rust" => :build

  conflicts_with "texlive", because: "both install `lualatex`, `pdflatex`, `xelatex` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tex-cli")
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

    system bin/"ratex", testpath/"sample.tex"

    assert_path_exists testpath/"sample.pdf"
  end
end
