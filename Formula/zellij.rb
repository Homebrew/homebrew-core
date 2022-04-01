class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.27.0.tar.gz"
  sha256 "6159482c25d3cb55b04d23230812f4450e88ff0975161594297a7deef8979a38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46cfd903d81897c35ee9d99063d42423923773da024b1f1ccf5949eb5ee700ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02ac6ed0c72bef49e5fd156030f1e00b2b5a559b5759ee438201843c5f3d13a7"
    sha256 cellar: :any_skip_relocation, monterey:       "c9073eaf0b03ed545187dbda00cf829318ee845d231a7d9fd76d7288db02a260"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9f153c541e5e079ffda1ddbac517a9c10f8a74555827e7cdf35b8284ba02576"
    sha256 cellar: :any_skip_relocation, catalina:       "a40f2234a2263a0c4698ca9adf18b9bfdcb65ed5ac0615ec5e1aca5a2bb6bbde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19cd9a25b0dc0cb2b11ca845b9068bf3bd8556251a7dcb4e9053a6f691792215"
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
