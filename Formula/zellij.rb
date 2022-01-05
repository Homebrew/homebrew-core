class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.24.0.tar.gz"
  sha256 "a7f2d1fa1dd9c55d37d1daebdf6af3c6666d144ee1e85ac7f805544ae03e3b1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f1d3838f7f61892f1d319fd9bd23b7fcfb835b6c1eafe50a640710a28aa2d1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de403c249ef2d6fdd64a408c3ebdb69a97636556e7c5872f37e0d9689e302887"
    sha256 cellar: :any_skip_relocation, monterey:       "0c0e3f798522a5816806e09a5d64566373d414165b56fbc28aa5ba1043c81e51"
    sha256 cellar: :any_skip_relocation, big_sur:        "1216902c3e0bea93e318256a6d3d958676e7055cf2b924453809f2f0d4283fbd"
    sha256 cellar: :any_skip_relocation, catalina:       "171ec5c19d3608d216d5433bc7177efb7715dbad5dff4b050a81162232a9ef8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "113f49ebc52d59931d310b66c70ef763725a79a314c4f38acdbfc8a5a0480e05"
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
