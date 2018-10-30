class Wandio < Formula
  desc "Transparently read from and write to zip, bzip2, lzma or zstd archives"
  homepage "https://research.wand.net.nz/software/libwandio.php"
  url "https://research.wand.net.nz/software/wandio/wandio-4.0.0.tar.gz"
  sha256 "f6d9c81c1ad0b7a99696c057fb02e5c04a9c240effd6bf587a5b02352ce86a9f"

  bottle do
    cellar :any
    sha256 "9964682cfb6e23baace99a67c86e821e1af876639abdc8da2f547a9af22cd1b2" => :mojave
    sha256 "758e3f124fa77a0c52431746e7a75da699c6717697662f696a70381050e0aa66" => :high_sierra
    sha256 "e0c976e9684b3cd990c21bc50fdb6c6bbc3a4bd77f0641e26f8741e0783fd999" => :sierra
    sha256 "921de26a27560963d4b4c92ce7e7afa852ad7e1a949184933245d8404a48f1ed" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--with-http",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wandiocat", "-h"
  end
end
