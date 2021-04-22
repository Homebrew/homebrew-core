class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.52.1.tar.gz"
  sha256 "7fa3fad6940276a62b7c6250be34ba544e37652f9de706b48ddf9bcee74ce3d8"
  license "ISC"
  head "https://github.com/starship/starship.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5488b76b6e66f6249702f73eef279f59435afbea53204746a6a36a12ecc546d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "74b806cff1ed144ab19898eae70985faa62022117995039fdb672c25a2509e92"
    sha256 cellar: :any_skip_relocation, catalina:      "3e3a32215ce194bc9f40cafd155cd57718fc77e2f722252f1e434e8a82935d48"
    sha256 cellar: :any_skip_relocation, mojave:        "260a1e5f732414589e9ca004ff5c406a64640489f647ad5e86458f8410ce06b7"
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
