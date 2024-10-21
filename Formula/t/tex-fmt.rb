class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https://github.com/WGUNDERWOOD/tex-fmt"
  url "https://github.com/WGUNDERWOOD/tex-fmt/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "d3c173742645e3228d0cca9f18c7cc39c5dc8d3d0eb9c5cd3925f5cc80d12044"
  license "MIT"
  head "https://github.com/WGUNDERWOOD/tex-fmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37203452b701cc1a4d1eb268ab8c11ae89e15f89fa7315ebc18c269f3dfb76a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93b9f25d7960216895776a0e93adec5902d131e3d0ed2a07e69163f5ef686868"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1037f9b8c3310740537cc4bf07cba86f73c8ee72754599d3546edcd06f17a60c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9996d9f2df71ba31a6cbd2ac9d1d821f52be60c4915f648cb39664fe0e715fe"
    sha256 cellar: :any_skip_relocation, ventura:       "1ac10f128361708b1c90e34a140f52f680e096f5c00daf31041b689878306b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f04cfa963bce3a95f3d674e9cb9c0f17eb9268761a39529bc4dff639538e9481"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\title{tex-fmt Homebrew Test}
      \\begin{document}
      \\maketitle
      \\begin{itemize}
      \\item Hello
      \\item World
      \\end{itemize}
      \\end{document}
    EOS

    assert_equal <<~EOS, shell_output("#{bin}/tex-fmt --print #{testpath}/test.tex").chomp
      \\documentclass{article}
      \\title{tex-fmt Homebrew Test}
      \\begin{document}
      \\maketitle
      \\begin{itemize}
        \\item Hello
        \\item World
      \\end{itemize}
      \\end{document}
    EOS

    assert_match version.to_s, shell_output("#{bin}/tex-fmt --version")
  end
end
