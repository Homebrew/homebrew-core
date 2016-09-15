class Symlinks < Formula
  desc "is a simple tool to help find and remedy problematic symbolic links."
  homepage "https://github.com/brandt/symlinks"
  url "https://github.com/brandt/symlinks/archive/v1.4.3.tar.gz"
  sha256 "27105b2898f28fd53d52cb6fa77da1c1f3b38e6a0fc2a66bf8a25cd546cb30b2"

  def install
    system "make", "install"
    bin.install "symlinks"
    man8.install "symlinks.8"
  end

  test do
    system "#{bin}/symlinks"
  end
end
