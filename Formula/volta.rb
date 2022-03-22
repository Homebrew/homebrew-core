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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44c1672b22ac6997816975c06a185151dc1a6305c06b1bb7dbc6e02882f1ec25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dbcd14a0a63d19d4ac28d20b20d849a14369374cb36f68cc4ae994208324ff6"
    sha256 cellar: :any_skip_relocation, monterey:       "73c1e9af6126f410f2c83804faf14676441e02bb96b51c75d1ead9cf3037cb1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f43ad29f446309d9c9fca3031b58dec129134a24dbabdca703e8bf1de6b035cb"
    sha256 cellar: :any_skip_relocation, catalina:       "8587132e7bc5b76dcac2f47372494a0bc1ceccf19e4eeecc6e29f12f9f8bc824"
    sha256 cellar: :any_skip_relocation, mojave:         "ade25632752bf387752f88e015694a0b1e353df3922357b51f846b4bfde9ccf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dc1d22a589d988d41f306aca5078cae2686849b57b31dbae88f963a2b89f6b6"
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
