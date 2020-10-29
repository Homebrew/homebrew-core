class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.46.2.tar.gz"
  sha256 "39301c8118239eda7b6d8dbcae498f28bfd901932e69003c249d99ee7989c1bb"
  license "ISC"
  revision 1
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fff0b5db2e027d157eb330302642f59f34053e46abe4c15c434598959045f329" => :catalina
    sha256 "73a9d9c97ef62886a8be85963e6cd23a7aa38a5bbd390decbe18f42e1d491aeb" => :mojave
    sha256 "2595690129f769c19234d819e192ea4de6f8eeda639bc57d82adc87f3658f069" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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
