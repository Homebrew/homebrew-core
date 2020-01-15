class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.3.1.tar.gz"
  sha256 "ef4822d2fdafd2be8e0cabc3ec3c806ae29b8268e932c5e9a4cd5585f37f9f77"
  revision 1

  bottle do
    cellar :any
    sha256 "82822d910206a4ad8e90bfc61b04c0fb6c744bf76e9bf0aa06e35ecc08b34ae4" => :catalina
    sha256 "8ee812d0bf59bb34fd25b0c294c642e921b1af65f8d94e649e1d824e7b5dbb03" => :mojave
    sha256 "91ece067e0ac677d93fa1bdfa3e7db825e2950dd1feae0ee031d8e2522260155" => :high_sierra
  end

  depends_on "python@3.8" => :build

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
