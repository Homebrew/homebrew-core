class Tundra < Formula
  desc "Code build system that tries to be accurate and fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.0.tar.gz"
  version "2.0"
  sha256 "bee27c6df2b2960c2075e911fe04daa444b0185083a0c8615ee12434e7e23ed6"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/tundra2", "-h"
  end
end
