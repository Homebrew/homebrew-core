class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v1.0.6",
      revision: "5be0e1f08982cf7969a68265cf19b77482cf480c"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa45d030db63b2712bc8a0171778cd0948593175b345b3cc0132bd4195ab5710"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65f1794cb06b3529b1ec7fb35cc7a42f6b81a1808b5840ba8d47840b6771921d"
    sha256 cellar: :any_skip_relocation, monterey:       "fa1b1a3dd051cec48fa3e3a071d4a97d3b9f9369108ad0e4b4cefb949a4d6805"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f94e94367a4c143c5030d25019edbef187de65168541017f002d7b883f81413"
    sha256 cellar: :any_skip_relocation, catalina:       "59b00d625ad61b3ec4b4cefbf8fffe30ba949bda277abfeb063d67da4ff08a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ec7abb3eddfb19529c8b8ea465d8dfe2af014d35087e3dbe6a4836d1df5b2cc"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
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
