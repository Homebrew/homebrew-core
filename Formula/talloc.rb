class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.1.11.tar.gz"
  sha256 "639eb35556a0af999123c4d883e79be05ff9f00ab4f9e4ac2e5775f9c5eeeed3"

  bottle do
    cellar :any
    sha256 "01743fa004981e73f9c7ace8625ae5975ede8f4fe2bab218e09b002876d63e62" => :high_sierra
    sha256 "3cde9259d92be99440227670fe1c295d3651f92a1daad6d8fe30038823311274" => :sierra
    sha256 "ceefd04e6ce90d617b7968e1ea0dc0bf5f81c84c70b1bc003f92de62976701cb" => :el_capitan
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
