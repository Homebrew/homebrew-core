class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.7.2.tar.gz"
  sha256 "f013c8a4e9933afd1097908087a31309c6b6874434652382990c88201798f2aa"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34ef08b70e078b1aba573c7b694ce535290b760eaa84ee437bb2ca975a5d81c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "497cb5fb8e4a655f800eb2800c69187a739f27b2ab8231c0d978526146a36fb6"
    sha256 cellar: :any_skip_relocation, monterey:       "39f88538ff731f7f6a876b9512924e3dabe33e85241d1700304316e475fc99d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c43410223435705ed5ab89d00227563aeaca4682daf90b7090106f0fddee0f0"
    sha256 cellar: :any_skip_relocation, catalina:       "85254dcfe8419b01b1092c7e2c117d172bf08b5da8d8800b42c2300321fcf54f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2223608da440c569be2486f43583f224a487cd489e319a3b5bbb719d28c90ae0"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    o = shell_output("WINDOWID=999999 #{bin}/t-rec 2>&1", 1).strip
    if OS.mac?
      assert_equal "Error: Cannot grab screenshot from CGDisplay of window id 999999", o
    else
      assert_equal "Error: Display parsing error", o
    end
  end
end
