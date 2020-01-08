class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.3.1.tar.gz"
  sha256 "ef4822d2fdafd2be8e0cabc3ec3c806ae29b8268e932c5e9a4cd5585f37f9f77"

  bottle do
    cellar :any
    sha256 "df5b955af4698ed58528ce0f4d952a37db18888512d9774e29312f9062d68d45" => :catalina
    sha256 "0c5c3e41c035e102e0988ce678e4741b619ac5abf33412804305adf88c7e2b9d" => :mojave
    sha256 "6ef5a361f585374386d314bb8c84ca120cb1d776c9de90dba6278f2b9292e910" => :high_sierra
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
