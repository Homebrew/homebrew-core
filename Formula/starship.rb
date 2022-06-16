class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.8.0.tar.gz"
  sha256 "398bf5b413ce5dfe4d3c5acceb0025f773478f28016609869821cf385448dcf5"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "920364a41c1e577b1fe4bec560726aaf50a89f3dcf9486ed738eb7656a1e1185"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4588bd9ccc90492cea6c10c5d8baed30c50bf64ce94e763b93c59323050df426"
    sha256 cellar: :any_skip_relocation, monterey:       "d25ca5b4b747cc986812b0afcc6d93e0da753ca316c8d577c5d8b2dcd823fc25"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7e512dadd8939073e29e3799be65ed86c817a6290b03ec453cec27b2e1ad726"
    sha256 cellar: :any_skip_relocation, catalina:       "7fe13f054e186b3a654f46444090610b3356095f6400631350040dc6fcb0e8e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ead91c278f2bf0afadbd6e373c9b83f29930cc221b132a04e4324f12e8e97bb"
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
