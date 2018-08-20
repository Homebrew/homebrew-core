class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.1.14.tar.gz"
  sha256 "b185602756a628bac507fa8af8b9df92ace69d27c0add5dab93190ad7c3367ce"

  bottle do
    cellar :any
    sha256 "f57a3c49190148c184c8c41e2872dacd7db4dba5174dab901a132594a806749b" => :mojave
    sha256 "ec36bac486e6f474745eadc80c421f3647205d6df7f13559c8b720a1dffb6cac" => :high_sierra
    sha256 "c95ae1f0a8bcb15608fa616dfc9282132ef575be9a9b3e1a79c6dcc8843dffb7" => :sierra
    sha256 "560fb76da75d8fdb6e81168e3123ffcce31eb44a6c186c0d929b79fb7af5cf5d" => :el_capitan
  end

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
