class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.31.4.tar.gz"
  sha256 "286b08523457cdadee89bb1839f8d08ac402af00f3e27063520a7ed9ee7afc8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d905ffd50add8ad25d06ea1fea1a55b684e8e161433754bf9be8c2c6d0333dbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "351d9cb81a69beaf0a89672a68877e9d8c18c61749f0055961a2f3ca7ff661c8"
    sha256 cellar: :any_skip_relocation, monterey:       "cb66f7df3af8548dfaa5b2df936c32368d6b510d9ff7d50cec844b20e4916492"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fa08e8f6c63b4426bd9a5b061eca97821d06c466a8e572ef50fd81cc5f51c30"
    sha256 cellar: :any_skip_relocation, catalina:       "fe1dc5cfbf7a278984d9d338058f832f3d9a974051ec91f057ed3586a3b4c252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d53f59182700ab47572e4715240f3e90fd942415d8563ec5950e720cfd0184b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match(/keybinds:.*/, shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
