class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.5.0.tar.gz"
  sha256 "89e0a03eeb4893de19dde750f44a227df4b56b5e23f32397769bb7dc9362de7f"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0dc5fa278fd3471e48fd88c9a32438ee64bbe76af168223209257e916c31c29" => :big_sur
    sha256 "e6d9025fc2431ff0d804c4dd48012403df72920606065ba97aaa5eefb5b428d7" => :arm64_big_sur
    sha256 "78864b412b392899987016508643a504502533cc8abe0551fe2aec47bf1c0989" => :catalina
    sha256 "3626f64942a310ec5dd37c3bff779418d8ec8d094514346db88f770932ecc162" => :mojave
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
