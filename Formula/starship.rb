class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.46.2.tar.gz"
  sha256 "39301c8118239eda7b6d8dbcae498f28bfd901932e69003c249d99ee7989c1bb"
  license "ISC"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eee2a63efffe4ce8672b11bddb3e905749a02a8e599d39df5ff0b8fceb07c63f" => :catalina
    sha256 "c0177cb35d9ed34b2b9d6723b220d3cc7e37f5fb839dd2426b91c64f63d6f999" => :mojave
    sha256 "77d533c2e216c0783e4a5465ea2f5300576769696ba309f9274e34b81ae54720" => :high_sierra
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
