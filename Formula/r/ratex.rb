class Ratex < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/ratex"
  url "https://github.com/leoliu0/ratex/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "409217da635398634808f50b315e54b22833cc42da9a47c82318256da510c1f8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/ratex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84aee572dc9406f2079aa3e4c31a2eedae5fdf7b948334440adfc2e48edee25f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e57b5bd531bda754ed248bc6134c8f5f2b75d39f8754e9b44ebfbc2ae4bbed9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19b2b9fadfc2c2bbb8332f05dd919242b979f7f29543971c9700b4a67c918989"
    sha256 cellar: :any,                 arm64_linux:       "7ba092f9443380aceb2c25f30efb178a57755547f2ba0977670cf8bdde90fb82"
    sha256 cellar: :any,                 x86_64_linux:      "b5409a24d37436f67e0682747fb51757befd89d5e4ccc506b7b551adab043878"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "ratex", *std_cargo_args(path: "crates/tex-cli")
    %w[latexdiff lualatex pdflatex tex-bibtex texmk xelatex].each { |cmd| bin.install_symlink "ratex" => cmd }
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
