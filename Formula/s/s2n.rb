class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "25f1f14092438d0919d60c4357990e1d2b734e3ffa9d8ecd86590abfd9407b00"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78968d71bd146ac09b55ebfe01597dbc0070d7ef3ea2a26ca8b897c5a48bf5ef"
    sha256 cellar: :any,                 arm64_sequoia: "6a95188a822a722aaa7d46d92505820e7275f121c839e0e1e04b0e398292a32e"
    sha256 cellar: :any,                 arm64_sonoma:  "91e3612dfb658de0c114f50437942392fd4da537fcf72a25da64758c7191e2c0"
    sha256 cellar: :any,                 sonoma:        "63e1060d9bd4723a29a98096c558780371fc27912ee7215263e3c07fca41d529"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d15607afa71bda3614aa6c98776707812ac761aa92848daa5f12f4eed57c68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "170804d3f51000d1e6fd4b7817734b1fc0120af3efb95966f1efb69c19bb5650"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
