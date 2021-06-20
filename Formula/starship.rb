class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.55.0.tar.gz"
  sha256 "34d63db5d34d6150cd62a5fa1333ab8922b7381ffb15ca8e6e2d5b4f9b79c4d5"
  license "ISC"
  head "https://github.com/starship/starship.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "31903635888839b61e44b2188f62537d3518f6a843eba736099c6893e1e218e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "067e82cacc903f629080dfba420ce399746687462ace76b2ff6647b817214b43"
    sha256 cellar: :any_skip_relocation, catalina:      "925141ca99c499ac594ca573107137dfab155829993bb59e12baddcd95892508"
    sha256 cellar: :any_skip_relocation, mojave:        "e1a2acdeaafb837ededbeed7aaee2e242fd2433985d6b3fb261858db4a64ad6f"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", "--features", "notify-rust", *std_cargo_args

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
