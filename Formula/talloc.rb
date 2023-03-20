class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.4.0.tar.gz"
  sha256 "6df36862c42466ef88f360444513870ef46934f9016c84383cc4008a7d0c46ba"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/talloc/"
    regex(/href=.*?talloc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9cc6716b82a3f101df6f96a1248c30e353f9b6e54aa96c713203fd26331d2d1e"
    sha256 cellar: :any,                 arm64_monterey: "66385ab5aea6e0860a78afba0447446c6d05bfa8f96ca28228d7c0c888f6416a"
    sha256 cellar: :any,                 arm64_big_sur:  "10399fed3af67859742c6a3ce0a9ba55df42a6cc6010c9985106bbbe96892c5e"
    sha256 cellar: :any,                 ventura:        "badda6ecc2492672bc46e8f7f9b2fa76353b2c6dfba643c92872849c808a6424"
    sha256 cellar: :any,                 monterey:       "9500982d196651f13d84d646f27b38cdaf933d556db6876d6fa9be0b4d1526f4"
    sha256 cellar: :any,                 big_sur:        "509abd7a4b2933eb6a13aaaa050ca656a928969ca59f73f948ac2b4283bbd9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "064f0103e484260a1a6b625ebe907079d61c508a61dea97ef65e7de02bc79982"
  end

  depends_on "python@3.11" => :build

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
