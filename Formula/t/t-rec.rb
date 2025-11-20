class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "1a6f39ebaf58f42b97b05cb6224f38aa805d221704b6cd1c9410e5ffb31fd850"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "125a7df2017104c98c23b1c14caada1a8e0b7017f4b2aebe12dce3ec8c2db279"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3127399303bab933fd27a0cabf74e89aaa3c2eaa17557193d1b471d79a42b65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36d085e1b2cb70029709cef5b0be8e7e0679e1476f6e2c7c6293a82aba079e51"
    sha256 cellar: :any_skip_relocation, sonoma:        "07d2abcc332279d088c154d5b1fceca1b7bdf39ee37a08ae1e8343cdd5db1d38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daff2771ea5d1de9f5eb714a82ecaaffe2297b22e1c8ce4f3abfbefd421ff549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a52d0c0ba90f2444beb949c2bff8350fe0eaea0c400b3d06e62ee04b7b9481e4"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    o = shell_output("WINDOWID=999999 #{bin}/t-rec 2>&1", 1).strip
    if OS.mac?
      assert_equal "Error: Cannot grab screenshot from CGDisplay of window id 999999", o
    else
      assert_equal "Error: $DISPLAY variable not set and no value was provided explicitly", o
    end
  end
end
