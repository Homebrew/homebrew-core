class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.51.0.tar.gz"
  sha256 "87a9e2ad206a7397e52e00a0a650d364ca2ea941cb9fbe75704d56a43f11cef9"
  license "ISC"
  head "https://github.com/starship/starship.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "992fbc07f611c871359f70e96709cd83527de0eb9b78981e2cf85fa0bf8c09a2"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4057beb592199c72945960780e133a6bbc0ba8493b3be524a7cb452ecc15611"
    sha256 cellar: :any_skip_relocation, catalina:      "1881da8ab97e614c5a31dc284fa2ed79b911eca4734500f5b81121b164da9953"
    sha256 cellar: :any_skip_relocation, mojave:        "a58de858346930f05259483c254ebecca3d60325145fc1e55f1153b2f4aed266"
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
