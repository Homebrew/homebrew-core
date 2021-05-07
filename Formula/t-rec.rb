class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.6.0.tar.gz"
  sha256 "08f290c92169342c6d301fa3ae9d8716332fb7f33848df3ea2236db33795ce54"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "da4d71225aa525bac71982d3110ebce3cee54a9a038e69931a31a820ef121b65"
    sha256 cellar: :any_skip_relocation, big_sur:       "bec63de408b3e5e61352bb61c2ca15b98e6b7181013feef2c74725858c59158e"
    sha256 cellar: :any_skip_relocation, catalina:      "b52aca2b1b2aaadc38f9ed9515aefe50970ef55ea202b7b243080f94d9af27b2"
    sha256 cellar: :any_skip_relocation, mojave:        "cd5e8883df8d66b5d18ea8db506946aba6dabcb558c21dcd01451371f41bf6b3"
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
