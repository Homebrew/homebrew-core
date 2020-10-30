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
    sha256 "5317a3f97ca314ac35ba276dbc5491722514d54e92bed181c8d4899a490a46b8" => :catalina
    sha256 "974a35cbc1e52f97b75c873e3e08be6411759bbe6e2ed80e1e7b2c01be8d9857" => :mojave
    sha256 "ebdba4a9896bffcb6428b28edab648a9fd743d9dd002f7e8a488a68d3fd6e9dd" => :high_sierra
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
