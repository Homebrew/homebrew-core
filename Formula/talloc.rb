class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.1.11.tar.gz"
  sha256 "639eb35556a0af999123c4d883e79be05ff9f00ab4f9e4ac2e5775f9c5eeeed3"

  bottle do
    cellar :any
    sha256 "f067641d705b891ecd10a13af13edde6670a24d4745ae1d867390fd97d373595" => :high_sierra
    sha256 "a9c830bacedca452b99f9ff33181fbe170a1a8ee4534b859704ba62ed0de974d" => :sierra
    sha256 "d6ec63f5bf8d85c274aab1bb635efc85284e3c71c908e5c1e7061c939ed814fc" => :el_capitan
    sha256 "4a9e0e1720e4294e4aa31d5c9ac5bc77e2d225a28f6ca8a3bd14fc645e85a7a7" => :yosemite
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
