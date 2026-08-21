class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.5.0.tar.gz"
  sha256 "912afa237510ae542a7733998eb18a12bcda35ab6729c8e2ddb43e8d0ebab007"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.samba.org/ftp/talloc/"
    regex(/href=.*?talloc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "33f78a2e466b5dd0585e61e12afb348d23c9f9c13a1b15372b0cd2580063fb10"
    sha256 cellar: :any, arm64_sequoia: "a1fc4bfee8a04ad313398302be7f1dfbed915faa22740d574fd6a32730830c4c"
    sha256 cellar: :any, arm64_sonoma:  "3afeb750b8c17993cb8b2bd55255b355de1174a711c75fbbf5a2cb74fa86c319"
    sha256 cellar: :any, sonoma:        "080e37d6daa1b360ca0b64f79e8f7230d64f8874ef1af168c87a3f6014cc56c5"
    sha256 cellar: :any, arm64_linux:   "b4cc50673735a834c31b1cc80e756d579b88c317f81efa816e85d2b3697deaeb"
    sha256 cellar: :any, x86_64_linux:  "3490cf833175989808b2f38118a501a5e6895069f7385dd0145abe0185a5dfdd"
  end

  uses_from_macos "python" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-rpath",
                          "--without-gettext",
                          "--disable-python"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltalloc", "-o", "test"
    system testpath/"test"
  end
end
