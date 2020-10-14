class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.46.2.tar.gz"
  sha256 "39301c8118239eda7b6d8dbcae498f28bfd901932e69003c249d99ee7989c1bb"
  license "ISC"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c6bdaaf8b3a3f18a5c13b674914adb5474428efae9255541a30ce4b86c1fb66" => :catalina
    sha256 "d8090b56eb20d60df867272e0f1550513272727a782f9b19b742c09356992c5a" => :mojave
    sha256 "5378cfef00826a09fa321b1fe28543ba5e4d807608626d5868048fec755fa24a" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

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
