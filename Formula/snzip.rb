class Snzip < Formula
  desc "Compression/decompression tool based on snappy"
  homepage "https://github.com/kubo/snzip"
  url "https://bintray.com/artifact/download/kubo/generic/snzip-1.0.4.tar.gz"
  sha256 "a45081354715d48ed31899508ebed04a41d4b4a91dca37b79fc3b8ee0c02e25e"
  revision 2

  bottle do
    cellar :any
    sha256 "823e1f1e956fa360c53a42d388bd8ae2743a9acaf7a5b5e0ef9917bedbd8fa0e" => :sierra
    sha256 "68b4d3fd3d9eaf7aca423e3ab5b4b70f132c1c93ecb0340ed9a955e4dc05e55a" => :el_capitan
    sha256 "48922501808047146276f2ba24babe2c1f31f4ba602bc31c9ad04bd28e95316d" => :yosemite
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
