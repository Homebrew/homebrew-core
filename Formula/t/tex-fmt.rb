class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https://github.com/WGUNDERWOOD/tex-fmt"
  url "https://github.com/WGUNDERWOOD/tex-fmt/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "e9dd89236781ea6f781b00d9452a071311cebd175424baea08bc03e8863f314c"
  license "MIT"
  head "https://github.com/WGUNDERWOOD/tex-fmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4d2575c418e61c4bff720eeb19852591a71c8d827acd85ea64f81457ee4ed4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "116a1f1e0acb70fd2acf1a7fe2d5f167913d41f526e457ba5e1c7ac527c0e5a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "918d7de84741a919de50c867fa54ff951b8bcbb368711b02e157b1e824a50ffc"
    sha256 cellar: :any_skip_relocation, sonoma:        "18ecd39663c00d2b38ab774f4fc739bab66bbf01c6d9f63334cbf662938a7f64"
    sha256 cellar: :any_skip_relocation, ventura:       "577521c80c447d1bbda632e7be5a12eb982a213f764ce63e9169e5ebb30941bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8d5037caf528c1142ed982b7423b192bd5bae89c032902cc7629478a66f5084"
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
