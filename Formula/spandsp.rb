class Spandsp < Formula
  desc "DSP functions library for telephony"
  homepage "https://web.archive.org/web/20220504064130/https://www.soft-switch.org/"
  url "https://web.archive.org/web/20220329161120/https://www.soft-switch.org/downloads/spandsp/spandsp-0.0.6.tar.gz"
  sha256 "cc053ac67e8ac4bb992f258fd94f275a7872df959f6a87763965feabfdcc9465"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d4a163f05a94cdabd07ce9dfbdeb0e78eb7a40891a2f58bb7c676d36c81020a3"
    sha256 cellar: :any,                 arm64_monterey: "68c43cb9a49a874a31020e96acf041e7a81c83abebebd03f81e4b24e2f462c7b"
    sha256 cellar: :any,                 arm64_big_sur:  "16f6c6a36a3c1cc4f322f1ecff38a6784e1aacc83c05c23dc0a15a74dc31fb5c"
    sha256 cellar: :any,                 ventura:        "487198f59730bb22c25c250fcac5c677726d5039011848138ed3cce168f108db"
    sha256 cellar: :any,                 monterey:       "11a2c48bd52753bb1f907fafb5d1defda7509eec0df434fc15e3b7dd5929d839"
    sha256 cellar: :any,                 big_sur:        "e07fb092214a411f46e4f3a7b1203f9265c247d533d89b8e48cc69315c1fd0ca"
    sha256 cellar: :any,                 catalina:       "a473944f4d1a3896e9b630aaff267d43d5681071e8bdede3a9ef34ab0bd6ed0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2970d79b9d79452fe323a3df25ff24355c308337c80cdeb7007fd7352837efc8"
  end

  depends_on "libtiff"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    ENV.deparallelize
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define SPANDSP_EXPOSE_INTERNAL_STRUCTURES
      #include <spandsp.h>

      int main()
      {
        t38_terminal_state_t t38;
        memset(&t38, 0, sizeof(t38));
        return (t38_terminal_init(&t38, 0, NULL, NULL) == NULL) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lspandsp", "-o", "test"
    system "./test"
  end
end
