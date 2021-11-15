class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.3.3.tar.gz"
  sha256 "6be95b2368bd0af1c4cd7a88146eb6ceea18e46c3ffc9330bf6262b40d1d8aaa"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/talloc/"
    regex(/href=.*?talloc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3a640fa631017960607750d8b9f9cabea5ca093622514451f98d7fd2920b9474"
    sha256 cellar: :any,                 arm64_big_sur:  "d231c44591841730b29b8b28af7792a5b3c8ed1fa393770c68e3706b0abd02e9"
    sha256 cellar: :any,                 monterey:       "bf7de6ff2b1363c60ab6f0aeb8ffb56297f4ca971b47d5aa6ceb71a1d46e422e"
    sha256 cellar: :any,                 big_sur:        "a99376ed4ddbe1ae05d843fc473c8eade0603c729f16fc880fe6e95e597b94bf"
    sha256 cellar: :any,                 catalina:       "41b41189b1177004fab7ab3764b607fd78844228d30182305dd81e33a85d388c"
    sha256 cellar: :any,                 mojave:         "da663459e3bf1cdaf72935823451b382bd3dee84cb151553f599921edb589d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "801236dc8f98f2e0d466ffc4ee0783ff66c78dff53f58b0905d9fe34a1725628"
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
