class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.4.1.tar.gz"
  sha256 "30c613ec26eba48b188d2520cfbe64244f3b1a541e60909ce9ed2efb381f5e8c"

  bottle do
    cellar :any
    sha256 "4b0f71d105368d57caf8037100cd79447d9b7e7d8eac3a167c65aa836d04d7ca" => :catalina
    sha256 "a0958b206cea28100f3aa0f08dc3d1be3de2eba641a44b293a44f42f9e43e261" => :mojave
    sha256 "1d504b757728f9f704884de3d347ebd22536e2cb86b4badafaec9aa3e9e915d8" => :high_sierra
    sha256 "894d7aaf7a86a7df034c773c9b62e1a8525cbbebf56870280a886ca0b80d5ae9" => :sierra
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
