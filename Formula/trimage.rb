class Trimage < Formula
  desc "Cross-platform tool for optimizing PNG and JPG files"
  homepage "https://trimage.org"
  url "https://github.com/Kilian/Trimage/archive/1.0.6.tar.gz"
  sha256 "60448b5a827691087a1bd016a68f84d8c457fc29179271f310fe5f9fa21415cf"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06945f0b2785db7539c7c40b1ed21f88d263906b565a20282c87830d35ab56d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a6dca1721ee66b96bcc5f010fb96657024b17059eefc82db0e61c6e2ff12a21"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb3768183ebb466b03e1134b498a0331e43f9aa19ca2f5fb3550f14bf28c1998"
    sha256 cellar: :any_skip_relocation, catalina:       "2174157bed654961ae8f5b1b60653c40a6a336aa4f26292ebe842d02652c62c5"
    sha256 cellar: :any_skip_relocation, mojave:         "638e2b76d476287fad690b99c20759798e1eab19bf3beadfad35c8f177bd59c8"
  end

  depends_on "advancecomp"
  depends_on "jpegoptim"
  depends_on "optipng"
  depends_on "pngcrush"
  depends_on "pyqt@5"
  depends_on "python@3.9"

  def install
    system "#{Formula["python@3.9"].opt_bin}/python3", "setup.py", "build"
    system "#{Formula["python@3.9"].opt_bin}/python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    cp test_fixtures("test.png"), testpath
    cp test_fixtures("test.jpg"), testpath
    assert_match "New Size", shell_output("#{bin}/trimage -f #{testpath}/test.png 2>1")
    assert_match "New Size", shell_output("#{bin}/trimage -f #{testpath}/test.jpg 2>1")
  end
end
