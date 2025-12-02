class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https://wgunderwood.github.io/tex-fmt/"
  url "https://github.com/WGUNDERWOOD/tex-fmt/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "84422be49ede7bfaa42949d192a9d7dfb2317c9e68edf3cf6abc346c8a19f036"
  license "MIT"
  head "https://github.com/WGUNDERWOOD/tex-fmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "308e7c17a6e05131ff3e483eee3845fa7287c5b41c20b45d2832b7ee75763ed2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "529746e62639558106ed94dfdeceed69b8c021629fb0b3581aab111831373981"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "890703e95c42436f8f80d74d2819a726238eaedb25d096629e8e0d9af216b6f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "93713998c6d2477d3981309c914b0cd7f54fd3eb7a5e2c7c3eb05c2d2c5eda83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3675c374858ef61f677ede0867d97efd2c06a7127ad8136d2c7a0fd5f5c83914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6800478c7df7b44b8437fdcc3c87133dd812445db40c7f4c98c2af4ff151afb3"
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
