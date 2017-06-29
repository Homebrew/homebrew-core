class Snzip < Formula
  desc "Compression/decompression tool based on snappy"
  homepage "https://github.com/kubo/snzip"
  url "https://bintray.com/artifact/download/kubo/generic/snzip-1.0.4.tar.gz"
  sha256 "a45081354715d48ed31899508ebed04a41d4b4a91dca37b79fc3b8ee0c02e25e"
  revision 1

  bottle do
    cellar :any
    sha256 "b15034887eb517ed04e4529a9781b6657ca4a9c184b8a72db70de62a42902661" => :sierra
    sha256 "272aced692ec9214e2829e8898f6af3054c8889fe2eddc20f3cc248e1d7e038f" => :el_capitan
    sha256 "3fca6b3f51e034880a90c3f218d9a39129a4acf3ebf0ed07f0127b9b7fd635bd" => :yosemite
  end

  depends_on "snappy"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.out").write "test"
    system "#{bin}/snzip", "test.out"
    system "#{bin}/snzip", "-d", "test.out.sz"
  end
end
