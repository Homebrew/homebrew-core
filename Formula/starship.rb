class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.44.0.tar.gz"
  sha256 "b002fa0e2b34ad59330a543461a51648751db4ae8d439d58065a3b9656772fe3"
  license "ISC"
  revision 1
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2d50878f224a8af2e0ab1e990d90166f7b4a02a82ebedc9acaa0a0443e04e4a" => :catalina
    sha256 "ff2ec8fa902206c5514b384db12bc36558987d55b335aeb3fddeafae416b5168" => :mojave
    sha256 "7955bc1b29268a4975f23d1312216cf71f50a9e05a82360cfb12a199831496d9" => :high_sierra
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
