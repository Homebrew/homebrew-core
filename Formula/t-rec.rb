class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.3.0.tar.gz"
  sha256 "124248b6a31d2f79175c597712357c8fc3354afd7b992df5d14f4ad8e078cc63"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "c895fe703a54317c8a9fbeabadf8bbf1910c18f7f7163a818796d5d70c7ace10" => :big_sur
    sha256 "6039e8741541b9e2a63e98f144f6ed400389d276c8bbba651b0a407fbff9fca4" => :catalina
    sha256 "83733e285f7bb41e547e117e6e8ee8a5d1a7b1dda87e322006826c0b55fc41e6" => :mojave
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
