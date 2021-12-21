class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.1.1.tar.gz"
  sha256 "5c3ada4b888068ba41052eb66ddc44c87c9a7428bebcc8a5cb7246db0ed780bb"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66f67beccc88ac4ee0370be11be52c2c2a9f0951888bfbc5d80ba03a4394d727"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2208708cd919e94e5b059411a523a852fafc955e0272cc1265e13a64c2b95444"
    sha256 cellar: :any_skip_relocation, monterey:       "6e5ada10a1551758b86f337227390fc5bd813f9d32cc76cde2f36dd821805c15"
    sha256 cellar: :any_skip_relocation, big_sur:        "14a303a81c45b5440ca590bca9730914913daeb7c9f8eccf90bf19ab03afb2c5"
    sha256 cellar: :any_skip_relocation, catalina:       "cd10450037a917776e065d67a0ae69f8bd5a65387be92580dfbf8a9440d377ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b2a09a35b977ce5b1d05d8d2f77a250236ba4636b3f6e05d629acfde959b89a"
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
