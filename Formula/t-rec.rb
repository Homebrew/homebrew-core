class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.4.3.tar.gz"
  sha256 "93e935bfb4f86da77f6dca9c2fe27d7ad0af3c795bb014ee0a1ba5afb2ae4d91"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "5834c8ba10e918e09a7dafb9d0fa105a43a49a806b976d3d782efa11d898b488" => :big_sur
    sha256 "5c62b07064981ce06ffd74ed2eba4d6b3736f66d23b0a0f748d98f0e56297562" => :arm64_big_sur
    sha256 "61bffa0f5cb4e18408da5c6da95c5bf1fd4f75db8778a67683377b183720fc5e" => :catalina
    sha256 "d8ace673e28fd8c6e1e81f08a92dffac20b8f094f963a3087c79da40072e27e2" => :mojave
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
