class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.5.4.tar.gz"
  sha256 "158003cd192f9375e504b9ab84d9239a06a8f9732cdd201243ab2fdcd38043f8"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c664c2de571200364a9b03159be0df8827001bf04b047dd8db6369c9af4b852f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bea112584d24f406d8ad63414ba497888192e36539a6dca766bd4f3278b22d8b"
    sha256 cellar: :any_skip_relocation, monterey:       "37276e7e830a8977bada2e2999207eef9cb3a6e80dce75395f8df68f21551c8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b63ebf06b3587f8dc118f88251f0d5530595f82ab159393a30928bd052c15144"
    sha256 cellar: :any_skip_relocation, catalina:       "b8d4fb545d1788347c83b007590af79ed4983821cfa3f93a373278995864c301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d93710523efcefd934c204bd527b30412ec4a37c0ba2d8199adef694967abce8"
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
