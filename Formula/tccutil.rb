class Tccutil < Formula
  desc "Utility to modify the macOS Accessibility Database (TCC.db)"
  homepage "https://github.com/jacobsalmela/tccutil"
  url "https://github.com/jacobsalmela/tccutil/archive/v1.2.7.tar.gz"
  sha256 "4584962a059584ba0810cee7912f9333ba6259da22bea7e6b3206bcf934d5cf1"
  license "GPL-2.0"
  head "https://github.com/jacobsalmela/tccutil.git"

  bottle :unneeded

  def install
    bin.install "tccutil.py" => "tccutil"
  end

  test do
    system "#{bin}/tccutil", "--help"
  end
end
