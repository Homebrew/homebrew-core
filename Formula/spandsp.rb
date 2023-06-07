class Spandsp < Formula
  desc "DSP functions library for telephony"
  homepage "https://web.archive.org/web/20220504064130/https://www.soft-switch.org/"
  url "https://web.archive.org/web/20220329161120/https://www.soft-switch.org/downloads/spandsp/spandsp-0.0.6.tar.gz"
  sha256 "cc053ac67e8ac4bb992f258fd94f275a7872df959f6a87763965feabfdcc9465"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1de79b77a71edef3e67c18da0b22400821a06190cd2c6e1363ed8bdf92fb6379"
    sha256 cellar: :any,                 arm64_monterey: "1dfce0ba8ff13c46c285baa0de02f0d2e82fae7b86ca5e81fdcd5b520924511b"
    sha256 cellar: :any,                 arm64_big_sur:  "de22c2ec1fe6dad211a9593851195445774f0e9d49768bfa663b50d8f26c12d0"
    sha256 cellar: :any,                 ventura:        "c950d3121cfcf2033617bac7b3c440ac07b5cba8166102f6fab8aeaa1eec20bb"
    sha256 cellar: :any,                 monterey:       "5a2514fe428dbc60642c6d787a0d7e2f9c337ee11c8e0cd10b8e67630919ab82"
    sha256 cellar: :any,                 big_sur:        "89a015496e6aedb1a07ae9186b799dfe96ae673213c27a9da9937d3d09ceb577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e56ef470947c1215482b5155d62c0c5a6c72485bbea7ce74bf6e8f1d629ab1e1"
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
