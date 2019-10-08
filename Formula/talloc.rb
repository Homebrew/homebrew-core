class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.3.0.tar.gz"
  sha256 "75d5bcb34482545a82ffb06da8f6c797f963a0da450d0830c669267b14992fc6"

  bottle do
    cellar :any
    sha256 "df14ec77e221af8b085b1d1031681e4a2223f447b8a5a543ce6864f73bb01e1c" => :catalina
    sha256 "11f688236046b8f2175be93f0d53faadddd8782acae480117ccc8544f3b04f88" => :mojave
    sha256 "2b173d2591652195f1005dace58eee6f43fe7f82410a67887dbe807293727f5b" => :high_sierra
    sha256 "1966ae9b4a5614cb15e6579211b8dc6440ef7e86c312b000637e959e2c89bd86" => :sierra
  end

  depends_on "python" => :build

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
