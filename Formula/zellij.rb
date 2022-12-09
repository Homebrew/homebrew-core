class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.34.3.tar.gz"
  sha256 "1cf1e5a87eb3bd458487b2db91cd8918b6df308de2809041fc62df30c50a735c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dccf17488f883cf10ea8a1f29c73c33dff0bcddf71816f3c12551a69fd97d20d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d165a2e32fffc38e33420a893fbc0f85c6f22b15713976edd9a390f7fb4aa61d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2df18ea7c063848e22963d1c5292308cc96e2dfe30e89bc09dc1d8b9781e8cb"
    sha256 cellar: :any_skip_relocation, ventura:        "c1c1cf14c867ffbcbd7c60623ae202828fd1a2d6665ce08172ad42dc9867c6e8"
    sha256 cellar: :any_skip_relocation, monterey:       "94632a69fa13ed0ea97d460a292db7501788deb0189fc230957e1901c262548c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfd9bacb74a663cf0833950999d75afd96df6c05e3d561712f668ff65bf28de2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f7eaaca99e65d9d74729e2bb66fedd40314569ac6b782d500584764e77d085a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
