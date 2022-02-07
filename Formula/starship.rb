class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.3.0.tar.gz"
  sha256 "3f29cb6e5cb7c673cbc1f8e91ceb4a0d1317d235b147db15e461ffec22be13a5"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15a94ead4d503a5e65fd03566131575d268ddf7b8e3667515c618d7c98d78c33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b042cbcdc60ce8ab9e31012cf5d789e6f089c7fcfdd7b485e430183f2f64842"
    sha256 cellar: :any_skip_relocation, monterey:       "f56cc13fdd246900c4fceb5daa000967fe5080ed2ecd2077738985e9455e8085"
    sha256 cellar: :any_skip_relocation, big_sur:        "8864eb91ce631525a500e401befcc79c587481cde88cd325c056d7f80a360102"
    sha256 cellar: :any_skip_relocation, catalina:       "07c2433523363a073dc56fa8895bf25aa101b3f13adb100ccadf45b4a78ae79e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5383738a61530f2ba302edd56c52acf99e015e84d1f53fc8b492c1aa184c7111"
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
