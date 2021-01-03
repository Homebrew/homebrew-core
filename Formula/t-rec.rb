class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.4.1.tar.gz"
  sha256 "38f0e33fa6e99efe59fda94bf6d7b818102b88f6af3b6236581fb4e60110cfbc"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "504f58788eaaa582b592a6e533affc4038dcba7110c0bb3d4d31bd0b6f9b82c0" => :big_sur
    sha256 "4fa53eaaf41d36d7439c20b2a48894b9e5168c2cf8fa28db958ca0b8ae1b2761" => :arm64_big_sur
    sha256 "55d448ac83aedec1ec408575cc0fe69e1a856d73335ad5f3415adf666fd1aabd" => :catalina
    sha256 "a4a7f1271cc66c7648f8727ef144c66445c9d1bbbee421c4d874bdfee8b34632" => :mojave
  end

  depends_on "rust" => :build
  depends_on "imagemagick"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # let's fetch the window id
    o = shell_output("#{bin}/t-rec -l | tail -1").strip
    win_id = o.split(/\s|\n/)[-1]
    # verify that it's an appropriate id
    assert_equal win_id && Integer(win_id).positive?, true

    # verify also error behaviour, as suggested
    o = shell_output("WINDOWID=999999 #{bin}/t-rec 2>&1", 1).strip
    assert_equal "Error: Cannot grab screenshot from CGDisplay of window id 999999", o
  end
end
