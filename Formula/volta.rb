class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v1.0.4",
      revision: "e4ab3604097bd48b5d32fa8adf69daa336d66c21"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b48dd9fcdeaf5bd99d19670b90435ecef8b40b0f6e8b406a302f1e7f0d9d804e"
    sha256 cellar: :any_skip_relocation, big_sur:       "b05113b680e109746163c3bf082ca7a2b2a00da1dcebb899416d7822e68d3a67"
    sha256 cellar: :any_skip_relocation, catalina:      "dc76e1f95915f42a5289f7f368cdd970771f002992200e19160d7ae89651ebd2"
    sha256 cellar: :any_skip_relocation, mojave:        "4f7ad7853a922751e34e48ac78656beea5fcb51b1c0c65f1d30010f2acbc85dc"
  end

  depends_on "rust" => :build

  uses_from_macos "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/volta", "completions", "bash")
    (bash_completion/"volta").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/volta", "completions", "zsh")
    (zsh_completion/"_volta").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/volta", "completions", "fish")
    (fish_completion/"volta.fish").write fish_output
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
