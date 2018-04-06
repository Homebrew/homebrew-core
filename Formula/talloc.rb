class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.1.13.tar.gz"
  sha256 "84f399dbf0ad97006a2b4953ea99452d033faac15aabfddd4ba61734764c6047"

  bottle do
    cellar :any
    sha256 "7c253d713cfee5cfc5802deebb527093d737fcf339396d0fd804c22d912d711f" => :high_sierra
    sha256 "cd39c2b0c43622780862b4725b0ff7d178a704c1c6020e633ab78c3d37205c05" => :sierra
    sha256 "bed9fd9c2af02a6cf42eda10539c1e5e7360a9c7bc6338bdf8524bc4f73119cc" => :el_capitan
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
