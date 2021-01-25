class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.3.1.tar.gz"
  sha256 "ef4822d2fdafd2be8e0cabc3ec3c806ae29b8268e932c5e9a4cd5585f37f9f77"
  revision 2

  livecheck do
    url "https://www.samba.org/ftp/talloc/"
    regex(/href=.*?talloc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "1ec1b32b844e7c4b8c00d67f400b9140a1d79637924e4cf198b306672c0130fa" => :big_sur
    sha256 "6060c8dc16c3a4947f12d8b41d03a164128f9475b7c5c93fda879797dc92be00" => :arm64_big_sur
    sha256 "f9b77cca02b56ffa431f45d49d090c21f1a762a47149d6e92d57884772dd0875" => :catalina
    sha256 "e0a573fbcce5380f8a31be002f14651f8f9e0cf43b254fe50100ae9134ff319a" => :mojave
    sha256 "c4c4ebb7d3e92b05abe832134c3f6745e8279a0585963e5a9967471b6c3a753a" => :high_sierra
  end

  depends_on "python@3.9" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-rpath",
                          "--without-gettext",
                          "--disable-python"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <talloc.h>
      int main()
      {
        int ret;
        TALLOC_CTX *tmp_ctx = talloc_new(NULL);
        if (tmp_ctx == NULL) {
          ret = 1;
          goto done;
        }
        ret = 0;
      done:
        talloc_free(tmp_ctx);
        return ret;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ltalloc", "test.c", "-o", "test"
    system testpath/"test"
  end
end
