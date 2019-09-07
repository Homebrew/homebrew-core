class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.3.0.tar.gz"
  sha256 "75d5bcb34482545a82ffb06da8f6c797f963a0da450d0830c669267b14992fc6"

  bottle do
    cellar :any
    sha256 "ff869573e3b472a59a8ffb3fb2e7eed6f31434a162a8e6391ab89d07957c5fd3" => :mojave
    sha256 "2619d7231ca1c73abaedf250e0e9bc84b2192881e59a780e724a8c423e4b7b01" => :high_sierra
    sha256 "369a50402a5eae387ce63cd63fb182b6e1fbce54e6b88204119dcf4c89d456be" => :sierra
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
