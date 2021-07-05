class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.14.0.tar.gz"
  sha256 "45ce99d0c13de562f27b46e9693ff0cdf1dba2d15568410fcb67c9b0e9d6b500"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f149b3a148bf00957ccfd407e0a82af73ab450635410ab6c00bf3bedced9e8f"
    sha256 cellar: :any_skip_relocation, big_sur:       "83e1d1dc75d2ff8c36fba477702368ab1ed795848d13ccd611d23943618144fc"
    sha256 cellar: :any_skip_relocation, catalina:      "ed561f0d71a74830809f8a88cb4ba755d1375fd36156786f24c806f45418c889"
    sha256 cellar: :any_skip_relocation, mojave:        "a6dff2f7e96f2b7659de6505abe7baf9d75cc82d324f2cec3b4a06e0bdda3d67"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "bash")
    (bash_completion/"zellij").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "zsh")
    (zsh_completion/"_zellij").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "fish")
    (fish_completion/"zellij.fish").write fish_output
  end

  test do
    assert_match(/keybinds:.*/, shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
