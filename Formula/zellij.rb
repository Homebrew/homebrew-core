class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.18.0.tar.gz"
  sha256 "0093f1bb2f6445a30266e218520088520fee21ddf646faefb1a16532c7034dbb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e307b8b13f9c56ebc56fe06adadcf8427507bfcca20cf25b7ce6f791406f7d68"
    sha256 cellar: :any_skip_relocation, big_sur:       "f35bb427a04983a53349fe49b0cb004f63c20ca14edb7ffbe31571469f6c9fb9"
    sha256 cellar: :any_skip_relocation, catalina:      "576bd09380f2dc8a7c725eb73ecb92516cc2b78a562d1cf1b071f9928ab66b99"
    sha256 cellar: :any_skip_relocation, mojave:        "54b06872569551e2a9675a9113fbd8821675475abdce93130557e1d38018ea1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80af33058c10e8379758dc41e3d3b4fcc1924ad6025dcb9563fcc747a1a30641"
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
