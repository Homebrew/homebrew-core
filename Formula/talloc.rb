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
    sha256 cellar: :any,                 arm64_ventura:  "0ae18aedff1c724c678e2bd828bad1d72182b0681146f7d4e194d7004732b9ee"
    sha256 cellar: :any,                 arm64_monterey: "14c38dbabaa0448ddea4576de5ac2fb6badf605c4db2ae4e5fa72c1ec19b4f95"
    sha256 cellar: :any,                 arm64_big_sur:  "75f15e5f72f21ee560283263719a256bfba325b510b420fa45775a1622b12de5"
    sha256 cellar: :any,                 ventura:        "7a60c53f6f3748c6300cdd96749577e0afabf80ec3767a5ea675bdcff0b7783a"
    sha256 cellar: :any,                 monterey:       "a7a0a524000d68b5e82bcb885e91a1944ecb372122f43424a2aeec684a23a512"
    sha256 cellar: :any,                 big_sur:        "b5df557121367248b6cce98c9a699414c357053ca90ced707e27749bf0ed84ac"
    sha256 cellar: :any,                 catalina:       "db80889b42ee0a260422deae04d5dbed0cfbabd0231e891b7231e5660fd70858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec65f462b96323ca4acc197a5c41d2370156057f594b5cd5dc2f97223a69fda"
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
