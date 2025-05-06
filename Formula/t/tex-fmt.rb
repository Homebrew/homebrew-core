class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https://wgunderwood.github.io/tex-fmt/"
  url "https://github.com/WGUNDERWOOD/tex-fmt/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "1a1bc787edb6b8f58feb6f0f5f33a6cac04ea583763f6807c6e319d6171b5d4b"
  license "MIT"
  head "https://github.com/WGUNDERWOOD/tex-fmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ba4991136e1b9c8cda2a7b6f32a0d4bd48e87b539b1d1cedefc5c48c7789b9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7953296bbf44226be974cfa83a6c72be562890e0953fc2a778eb8a6cc32264e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f54eebd133856d0df1a7c6a135d73c47bb4e26e80fa3d4290616fdd7f0a6fb1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3beceb95230080b3b4cdd2e333418c7924e86ba3ef01284f85b2c43ed86cd319"
    sha256 cellar: :any_skip_relocation, ventura:       "baf1ccee2323af100ca9f294fe532228fcf94d4f3f7ee4a36a37989f911e1829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f09adcafa4191bfe2aacaaa2a3308cb366a13c4c191bf3a57e005a1eb050031a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1113e066dd4f7ea74133893d88f4534fa705e16f276ee197de414ac0e0e4cf8a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"tex-fmt", "--completion")
    man1.install "man/tex-fmt.1"
  end

  test do
    (testpath/"test.tex").write <<~'TEX'
      \documentclass{article}
      \title{tex-fmt Homebrew Test}
      \begin{document}
      \maketitle
      \begin{itemize}
      \item Hello
      \item World
      \end{itemize}
      \end{document}
    TEX

    assert_equal <<~'TEX', shell_output("#{bin}/tex-fmt --print #{testpath}/test.tex")
      \documentclass{article}
      \title{tex-fmt Homebrew Test}
      \begin{document}
      \maketitle
      \begin{itemize}
        \item Hello
        \item World
      \end{itemize}
      \end{document}
    TEX

    assert_match version.to_s, shell_output("#{bin}/tex-fmt --version")
  end
end
