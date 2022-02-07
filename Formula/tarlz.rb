class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/plzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.22.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.22.tar.lz"
  sha256 "fccf7226fa24b55d326cab13f76ea349bec446c5a8df71a46d343099a05091dc"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "lzlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    lzipfilepath = testpath + "sample_in.txt.tar.lz"

    testfilepath.write "TEST CONTENT"

    system "#{bin}/tarlz -cf", testfilepath
    system "#{bin}/tarlz -xf", lzipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
