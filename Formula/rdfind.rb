class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.4.1.tar.gz"
  sha256 "30c613ec26eba48b188d2520cfbe64244f3b1a541e60909ce9ed2efb381f5e8c"

  bottle do
    cellar :any
    sha256 "ca83f17309001b90efbfbf1680d01632def8b5c6827b81f60f1bd64941af37d4" => :mojave
    sha256 "f9cf95ddb7039e4e1a9afcf84e92cb3abdcdcd8e95d9db1862a363b4399f5ea2" => :high_sierra
    sha256 "6e47f48f21af1db473c225fa8bb48682b865fd150fcc4794b0cc5e463cbbd73a" => :sierra
    sha256 "bd9e2a6f1c907f7032df5929b2d5b8ac8394cd3f54c6f0b0d72b753c212b519d" => :el_capitan
  end

  depends_on "nettle"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "folder"
    (testpath/"folder/file1").write("foo")
    (testpath/"folder/file2").write("bar")
    (testpath/"folder/file3").write("foo")
    system "#{bin}/rdfind", "-deleteduplicates", "true", "folder"
    assert_predicate testpath/"folder/file1", :exist?
    assert_predicate testpath/"folder/file2", :exist?
    refute_predicate testpath/"folder/file3", :exist?
  end
end
