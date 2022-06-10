class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.3.4.tar.gz"
  sha256 "179f9ebe265e67e4ab2c26cad2b7de4b6a77c6c212f966903382869f06be6505"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/talloc/"
    regex(/href=.*?talloc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "a0b8936aab48e933fe8152fbcf62aaae8fe275eaf633da10d8a3cc8850427ab8"
    sha256 cellar: :any,                 arm64_big_sur:  "416d686e27607c6cd1341da3ee1db0263bcea028b4644a7051c0acd6d2533b9c"
    sha256 cellar: :any,                 monterey:       "548b62389799fbc33f2457d242149d49e0347d13241591e370f753458eb4a746"
    sha256 cellar: :any,                 big_sur:        "72693abba030813551e05e682996bea4b9bcd6d9524faab3ab6a6ede826b482a"
    sha256 cellar: :any,                 catalina:       "1b69ab0589f68b580776015ad297dfdd12b734fdbe062884e9b5b8cb2ebb31b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f3f4cfdd6c4cad9505ef2cdf8522bb2ea0951d09119b78932d638fbd6aa176c"
  end

  depends_on "python@3.10" => :build

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
