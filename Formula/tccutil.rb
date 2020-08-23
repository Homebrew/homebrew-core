class Tccutil < Formula
  desc "Utility to modify the macOS Accessibility Database (TCC.db)"
  homepage "https://github.com/jacobsalmela/tccutil"
  url "https://github.com/jacobsalmela/tccutil/archive/v1.2.9.tar.gz"
  sha256 "8f1212c80f0df0ddcb76f921ae43a3e5c1e65044f68569b52cbef2c02e558157"
  license "GPL-2.0-or-later"
  head "https://github.com/jacobsalmela/tccutil.git"

  bottle :unneeded

  def install
    bin.install "tccutil.py" => "tccutil"
  end

  test do
    system "#{bin}/tccutil", "--help"
  end
end
