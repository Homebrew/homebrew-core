class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.4.2.tar.gz"
  sha256 "968f1d7f2e4274e2ff81df5f57383f73904ddfd1e379c9198b03ba2f5c725459"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4195888a33197b7d22f50e4fb7bb17ff237c2b30d89390f470bb45c38c6fd53" => :big_sur
    sha256 "6ede2cb92c9656dda7085b0506de109f43526446eee269b74240f5d109f7b896" => :arm64_big_sur
    sha256 "77e233b438d7215f4f7792b277881354d614c7916fcde89d81a9ef6c3886d4c8" => :catalina
    sha256 "948ea605e3655a8002e9223379362bead206b929c29ead731916779ea858209e" => :mojave
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
