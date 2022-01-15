class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.2.1.tar.gz"
  sha256 "22ad1622fd30297cc0ba2de67316e7df07c44cabe716bcbda3a5cb0d12375c98"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3ae7b58a629d07142a5c5594f286906bbbb8f76ca0dfb60560a119156cef88e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0f3cac0b2cbaaf5c4c3ae01f16af423997b2ca1b3579a63b5ab121ed4e13406"
    sha256 cellar: :any_skip_relocation, monterey:       "8af842dbab4849bb433d71c50c7e4b3c6959b9835c28ade358a9391e980e7486"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb0e970654a4aafe7751a649c68773f8e948da93cc3e1147d206dca39e7657a8"
    sha256 cellar: :any_skip_relocation, catalina:       "50c1dcfb1a32db301b30e1d3fcd8fc352fe3982d15eeb896e67e9cb27cc5397d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43664f186f557129ba235077897df81a056c5b87cf67068522939bfb8eb29958"
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
