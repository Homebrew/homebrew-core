class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.3.2.tar.gz"
  sha256 "27a03ef99e384d779124df755deb229cd1761f945eca6d200e8cfd9bf5297bd7"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/talloc/"
    regex(/href=.*?talloc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0075bc00e43000ac1e6aa959e7a0942a16e0097209be856cbe66b452fc937e27"
    sha256 cellar: :any, big_sur:       "52c7fce48dc4d2a7f9a9d04c6728df1ca6ef485f7e7f4db7a7f381d1069ae48b"
    sha256 cellar: :any, catalina:      "da325e962398aecb598415cbc629e3066c07904d3a7ac0e86d73a996ce44629c"
    sha256 cellar: :any, mojave:        "d16cc6d63e86849c6aad4bf0479dd245e20d488662845c4df41ffea359242995"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltalloc", "-o", "test"
    system testpath/"test"
  end
end
