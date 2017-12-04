class Remake < Formula
  desc "GNU Make with improved error handling, tracing, and a debugger"
  homepage "https://bashdb.sourceforge.io/remake"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.2%2Bdbg-1.4/remake-4.2.1%2Bdbg-1.4.tar.bz2"
  version "4.2.1-1.4"
  sha256 "55df3b2586ab90ac0983a049f1911c4a1d9b68f7715c69768fbb0405e96a0e7b"

  bottle do
    sha256 "3d3ab44424002f01faba037c83e6d0bf19f9477c71ebd63191f565f87574238e" => :high_sierra
    sha256 "6b8bcf13f7d7b879c005fa90e2d0afeade5ebf04887330aa5905bde2923e7186" => :sierra
    sha256 "ea8af9ddc7a22e0708ea44345c78fd0c900cef791096cc1091157580de152297" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all:
      \techo "Nothing here, move along"
    EOS
    system bin/"remake", "-x"
  end
end
