class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.4.2.tar.gz"
  sha256 "d7d1a4fb661c1612617306f4a99bacccdffca4210a51cb1b91e87fb005bbd32e"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b6c86661aa5e0e853f98bef10047e6d18acddb9b8b135fe8f27068a348e2487"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "558354061a0fc2cfb5d63fd44ee54af623c8e866f9dd00b71dca662367a1a290"
    sha256 cellar: :any_skip_relocation, monterey:       "7318ddbd100d42c6e6dc079553dc10f11e61151bd2a3141eb0d74c81c876ac12"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c3727771244c2e99b0d3dd1b81ab0001182b7410b18156c0aacac9a2980fe3b"
    sha256 cellar: :any_skip_relocation, catalina:       "6ccc6cc7c759ffb8a458a3037430fddfd1ea29c1b420dfe6ba8ab6a414050ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4cee0a79c56869f092a0269fb78b210f8782cd2bfa4c5217cda6663fc5f7f37"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/starship", "completions", "bash")
    (bash_completion/"starship").write bash_output

    zsh_output = Utils.safe_popen_read("#{bin}/starship", "completions", "zsh")
    (zsh_completion/"_starship").write zsh_output

    fish_output = Utils.safe_popen_read("#{bin}/starship", "completions", "fish")
    (fish_completion/"starship.fish").write fish_output
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
