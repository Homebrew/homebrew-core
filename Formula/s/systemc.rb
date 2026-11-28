class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://systemc.org/overview/systemc/"
  url "https://github.com/accellera-official/systemc/archive/refs/tags/3.0.3.tar.gz"
  sha256 "6b4906fe564c81941b5d57c75ee9b20c44c3f4ead1cf607f38ff7beea9aacce4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "f08e274ed9253ba97c15170240f0e711cfae591aa217c47639ce0fe378e85a10"
    sha256 cellar: :any, arm64_golden_gate: "fcd5186cdeab5b80b87cfa28ee9ff624a60bf5d0ffa41ae3dc21756f228b0c4b"
    sha256 cellar: :any, arm64_tahoe:       "c008aa010a53956b9aa13a13d7a7b0f7ea26787f24cc6f40c93a72d6d9a2792c"
    sha256 cellar: :any, arm64_sequoia:     "8560e9ae47a230b7bbec101b4f865b71782d9fc6af3eff00d92b9cd777fed492"
    sha256 cellar: :any, arm64_linux:       "ddf90d22af1cfec1739170292688e17b9757b8d1e1d28f0fc006d01d4e05b4b6"
    sha256 cellar: :any, x86_64_linux:      "0a36fe41e9ff4727ec773bbcb6bdf972f17fe58cc75950dd1405e39c4bd2556d"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "systemc.h"

      int sc_main(int argc, char *argv[]) {
        return 0;
      }
    CPP
    system ENV.cxx, "-std=gnu++17", "-L#{lib}", "-lsystemc", "test.cpp"
    system "./a.out"
  end
end
