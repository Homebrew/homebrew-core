class Symlinks < Formula
  desc "Symbolic link maintenance utility"
  homepage "https://github.com/brandt/symlinks"
  url "https://github.com/brandt/symlinks/archive/v1.4.3.tar.gz"
  sha256 "27105b2898f28fd53d52cb6fa77da1c1f3b38e6a0fc2a66bf8a25cd546cb30b2"
  license "MIT"

  def install
    system ENV.cc, "-Wall", "-Wstrict-prototypes", "-O2", "-o", "symlinks", "symlinks.c"
    mkdir man
    cp "symlinks.8", man
    mkdir bin
    cp "symlinks", "#{bin}/"
  end

  test do
    system "#{bin}/symlinks", "-h"
  end
end

