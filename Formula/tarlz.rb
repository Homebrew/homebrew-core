class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
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
    spath = testpath + "source"
    dpath = testpath + "destination"
    stestfilepath = spath + "test.txt"
    dtestfilepath = dpath + "source/test.txt"
    lzipfilepath = testpath + "test.tar.lz"
    stestfilepath.write "TEST CONTENT"

    mkdir_p spath
    mkdir_p dpath

    system "#{bin}/tarlz", "-C", "#{testpath}", "-cf", "#{lzipfilepath}", "source"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_predicate lzipfilepath, :exist?

    system "#{bin}/tarlz", "-C", dpath, "-xf", lzipfilepath
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_equal "TEST CONTENT", dtestfilepath.read

  end
end
