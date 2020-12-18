class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.3.1.tar.gz"
  sha256 "aac0d1cc10d00295b089bc75b90987d0e92d5a371367fff57970abaef60a4136"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fd5f00875c39f075ca19d6b6030c5e8f7cbd0085fa1fa627df40af102441c17" => :big_sur
    sha256 "a32f243bf866f9966e945ced67ebab185763707600422ee1aadd4f00b7a6fde2" => :catalina
    sha256 "752857bd8be9fcf9cd769411eadff503242e1148ec4916283a9ee8acc66389a5" => :mojave
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
