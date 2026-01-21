class Spandsp < Formula
  desc "DSP functions library for telephony"
  homepage "https://www.soft-switch.org/"
  url "https://www.soft-switch.org/downloads/spandsp/spandsp-0.0.6.tar.gz"
  sha256 "cc053ac67e8ac4bb992f258fd94f275a7872df959f6a87763965feabfdcc9465"
  license "LGPL-2.1-only"
  revision 3

  livecheck do
    url "https://www.soft-switch.org/downloads/spandsp/"
    regex(/href=.*?spandsp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "7eb7c7c0692b996402f9debbb20b3d87f5a0e9c17c2c3c73c5ce0589175c104a"
    sha256 cellar: :any,                 arm64_sequoia:  "fb9acce46b687e18c6e016cf9db9be77645778722eccc71589bc06b7fa7c6344"
    sha256 cellar: :any,                 arm64_sonoma:   "c0031a76da7569594a6e541f5373a81fd8fd67fe51d8ded0bc317c22b7c9d61b"
    sha256 cellar: :any,                 arm64_ventura:  "1de79b77a71edef3e67c18da0b22400821a06190cd2c6e1363ed8bdf92fb6379"
    sha256 cellar: :any,                 arm64_monterey: "1dfce0ba8ff13c46c285baa0de02f0d2e82fae7b86ca5e81fdcd5b520924511b"
    sha256 cellar: :any,                 arm64_big_sur:  "de22c2ec1fe6dad211a9593851195445774f0e9d49768bfa663b50d8f26c12d0"
    sha256 cellar: :any,                 sonoma:         "97da2e382c38c039845f20c0299bee1568ed0d45cec38662427a531fc9091202"
    sha256 cellar: :any,                 ventura:        "c950d3121cfcf2033617bac7b3c440ac07b5cba8166102f6fab8aeaa1eec20bb"
    sha256 cellar: :any,                 monterey:       "5a2514fe428dbc60642c6d787a0d7e2f9c337ee11c8e0cd10b8e67630919ab82"
    sha256 cellar: :any,                 big_sur:        "89a015496e6aedb1a07ae9186b799dfe96ae673213c27a9da9937d3d09ceb577"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ca858d2c651cb3176d0e89acb9350b584f884238fc4e285cf7d3fa69d45ff23b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e56ef470947c1215482b5155d62c0c5a6c72485bbea7ce74bf6e8f1d629ab1e1"
  end

  depends_on "libtiff"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    ENV.deparallelize
    args = ["--disable-silent-rules"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #define SPANDSP_EXPOSE_INTERNAL_STRUCTURES
      #include <spandsp.h>

      int main()
      {
        t38_terminal_state_t t38;
        memset(&t38, 0, sizeof(t38));
        return (t38_terminal_init(&t38, 0, NULL, NULL) == NULL) ? 0 : 1;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lspandsp", "-o", "test"
    system "./test"
  end
end
