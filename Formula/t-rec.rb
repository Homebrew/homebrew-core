class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.5.2.tar.gz"
  sha256 "ec3632a2cf2dc8a5b35d09c9ac4d60d5fb76f8b359feb65b9f83c85331c51756"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ac84e8e88ecbbb95052bf6d1558e78ec330ffd4bde22817a698b93b5237088dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "481cf51433f6a0bedaa94ef82f8eee2b87159a7e1bd7662fe5152fefb3b3fed8"
    sha256 cellar: :any_skip_relocation, catalina:      "72ec2d14f1024aaff7a07b5e954659e4819616bc010aa54f9848089e1ef98bd0"
    sha256 cellar: :any_skip_relocation, mojave:        "8b7820252f6fce491940d881d3b44f70138670601b3e50917a5357d13b5db274"
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
