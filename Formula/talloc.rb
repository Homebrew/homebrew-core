class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.1.14.tar.gz"
  sha256 "b185602756a628bac507fa8af8b9df92ace69d27c0add5dab93190ad7c3367ce"

  bottle do
    cellar :any
    sha256 "89badf631b95b7d4f447da5c6d7ca93949df26ecdf0ba57f965314f70d3aeaa3" => :high_sierra
    sha256 "68d41383b977d79d569e740a06480f0419a840d06fd108df1198a8f14521f85c" => :sierra
    sha256 "50b9fc4ccf02a98b2d44b0b34781e89f9160c9b37e3d9a8a133ead93a8b3839d" => :el_capitan
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
