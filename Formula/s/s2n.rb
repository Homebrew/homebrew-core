class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://aws.github.io/s2n-tls/usage-guide/"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.12.tar.gz"
  sha256 "76d3e6125ad8f7d960a62bf1e18c451fb75ed6ab640247b046b5b0f55d39d099"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "06dafe9143c2a1d3968a71f6d5c4cf6fd674624a3dd8b6a65ac3dbe2591c4f35"
    sha256 cellar: :any, arm64_tahoe:       "aca2486a3a6cd04d5bc5c1d2eeb390ed5a4c30627bf6fed1e5eaf2c8b67d5288"
    sha256 cellar: :any, arm64_sequoia:     "f048624684cbc99232bfd72d7d716e3a3f2dcb83d15585f69a679b7b3b19bd5e"
    sha256 cellar: :any, arm64_linux:       "e27d5f7bff188b2a9f8472e92295b4fc892bdd2a23043568e88f0925ec84260f"
    sha256 cellar: :any, x86_64_linux:      "e505b00696d2d5a39bd7531a62526434452dfdc322b765e485afc73ccc7d0ef3"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

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
