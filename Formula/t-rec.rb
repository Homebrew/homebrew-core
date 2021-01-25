class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.5.0.tar.gz"
  sha256 "89e0a03eeb4893de19dde750f44a227df4b56b5e23f32397769bb7dc9362de7f"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "70730794a535317f4af96876cc61095f3fd92d1306a41c03e6207f645a891609" => :big_sur
    sha256 "1419e611ff929071f7662ae68b19652655ff34aa2a7649df82145b9c0bbcf7a7" => :arm64_big_sur
    sha256 "6d6324c92f0b2a9f1f53924206025a78272b73602cbac9fbc26216780f05475e" => :catalina
    sha256 "9b1a76bac6d4ccbdb33b4d054450a8bb4fe2411eed54f5967d067b95391fa7a0" => :mojave
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
