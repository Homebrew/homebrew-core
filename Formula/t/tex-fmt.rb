class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https://wgunderwood.github.io/tex-fmt/"
  url "https://github.com/WGUNDERWOOD/tex-fmt/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "fee9ccd8f13be00cf437ce73928892eb0b55349bd4c81e226bc3fd3cb9de644c"
  license "MIT"
  head "https://github.com/WGUNDERWOOD/tex-fmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5be164037ac7b438000cef392c642d0aaa44dcec7d6c6f5697ba5fa292a1b098"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2e644f93e0b05d1c7d7de759828490398907480bb54670f1dabe8f4feaff18b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23fa5f27f2598686e652f992565fa80694e36fcac2e9585d2c3fb6a3de88aa07"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb4acc89497665495792222dabb1b748ba7af1f9d22539a22e3a4c212a89351d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c88d676684f0ee36cea1beef980bcbf89d950bbe8f1a3a28a975af65b7f06cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d687c3d3889c07d59801d34bbbbb733fc29751fa34d607c9fe48ee096ad15430"
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
