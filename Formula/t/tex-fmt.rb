class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https://wgunderwood.github.io/tex-fmt/"
  url "https://github.com/WGUNDERWOOD/tex-fmt/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "383c1620bf789945b04359127adb222118926eea7576910eb6779fb0dcdf9cdc"
  license "MIT"
  head "https://github.com/WGUNDERWOOD/tex-fmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45757bf083d51e7d16f599afaec870417abe6e8691b5b408d8f0c0ace3425260"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "115ded0add4c2317395e13907e2f205dce9a53c154874a51b453338acad73410"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5b5bf07197ab5a05da982261820ec10905dd27b760f3f0c0715d2cba4f7ed5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "29c1b48634e64dcf41253f21e330e529db248c150e79f9be91bf5f897c887265"
    sha256 cellar: :any_skip_relocation, ventura:       "10dc3e6347611707c23641d9306fc3ea515dcf54b2ab5f982c578f86a25e72ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3973667d4882d89574a002c7cb737ec934b1a502296466a64fff42826b143c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72f0e6eb4ec9c2ae4018168ff6f0388ae97805287e217106c14db8ff5767332b"
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
