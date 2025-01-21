class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.3.8.tar.gz"
  sha256 "2826c26a84486af8e94ab08172b5538bc1d214a4d85bc5f1293acbc2e5d51ccf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78019b848362a93f2ea1f41e0222dd066db4c89f0445cacf28e4c5b61b20c8d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e65e6dbab06ad7f1f28aaed1ebf9817c5fb07113bd82ec459ba77afbef296c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "155825cea7216bf225732f783e4dc047a55d481698e9f6fbd959612aa7a8666e"
    sha256 cellar: :any_skip_relocation, sonoma:        "73cfe3f1b037e9d4db0779256d018556259224ccd537cc700dff6be45ac34c58"
    sha256 cellar: :any_skip_relocation, ventura:       "bbed39e157bee858b45967b06eb226275bd59f1c509af177ccc3486851afc9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1b71c316d0fdd100c98771cbad44d5b625f13282466e2aed7731fd8bb225c32"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
