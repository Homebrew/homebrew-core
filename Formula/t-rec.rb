class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.6.1.tar.gz"
  sha256 "ffbfd854bafe29e47dceadaf615e2d09cc64032396ebe90409601ec91967cbc7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fbde032a894b3e3280bc46e635812595f35e6c27fd12c76efb73050b07bb7fd4"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca5a62f295d80a1a404fc841201567a5477998d9808463de763a864c94b2028c"
    sha256 cellar: :any_skip_relocation, catalina:      "b34edd8aa8158307bb2456d47d856ab8d1fbd9e3877cef5b31d30f6110ee9ef6"
    sha256 cellar: :any_skip_relocation, mojave:        "12a269fcd0da0ac0ae6ecb7d336001862f013d928ed31e5a64ff33372f2082db"
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
