class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.31.4.tar.gz"
  sha256 "286b08523457cdadee89bb1839f8d08ac402af00f3e27063520a7ed9ee7afc8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e93a21f0963b6071a60bdb572c008fb9aa80f1b80ad985b0feed01b33c4f1bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b811eb9747bb2195848372c95a5bfe01390404ad5dd361a9436940cf2470209"
    sha256 cellar: :any_skip_relocation, monterey:       "9e2fa6f827a5751dc62c0e0dca528f12d2205d8872ce551ba48b3f8b8d9afffc"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa40ddd39c2c743a2947f51867e02fa313c0e24397b8b35d91a72c73c55e2eba"
    sha256 cellar: :any_skip_relocation, catalina:       "dee94b6b2596c37675313aa07c72bee3d4cd6fe50850d5644887d9dff00386c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eedaa5cb90d3b1392104d0fb27080030f518889011ccf27bc8e269334965315"
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
