class Remake < Formula
  desc "GNU Make with improved error handling, tracing, and a debugger"
  homepage "https://bashdb.sourceforge.io/remake"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.1%2Bdbg-1.2/remake-4.1%2Bdbg1.2.tar.bz2"
  version "4.1-1.2"
  sha256 "cc6bae282c064b66a3d058133d682fc445b8cf8916f5a875150c379dcf7b4a9e"

  bottle do
    sha256 "442fd8ead728131cf4b6844ea05e6d285e93f5ddd56afb3ff2d419f4ac467275" => :sierra
    sha256 "acf1304abfe8aafc9795519d7bced2e48a30e756d59e354402f0476ce497ced6" => :el_capitan
    sha256 "08379f9f4deb5700416c7a65dd2f46fe00e4a9d91e0c036dc877fdabe86a8001" => :yosemite
    sha256 "a6a8e14b9abad883c20c76e26226018864245e21ac934984f5131a0846784fda" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<-EOS.undent
      all:
      \techo "Nothing here, move along"
    EOS
    system bin/"remake", "-x"
  end
end
