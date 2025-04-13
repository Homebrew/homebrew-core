class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://systemc.org/overview/systemc/"
  url "https://github.com/accellera-official/systemc/archive/refs/tags/3.0.1.tar.gz"
  sha256 "d07765d0d2ffd6c01767880d0c6aaf53cd9487975f898c593ffffd713258fcbb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "441b9e5eeeb6d385c2cfcf2c6500d24c42b67d3bd4ed37b3d8eff2499b71f061"
    sha256 cellar: :any,                 arm64_sonoma:  "3a0cde321c4507f2167a85f007b41f746428892da203926ec36349bd3772b32e"
    sha256 cellar: :any,                 arm64_ventura: "0318c7fe56225d68c28f70aced8caf7e29481bd54b143abd2e8c1979e6046a9c"
    sha256 cellar: :any,                 sonoma:        "cce974365677a77f35b9e9210c458fc3983c24bd2f71607cac18acd43d718491"
    sha256 cellar: :any,                 ventura:       "dba48d318338030082a310813e68f3708029a7fb9a69a323bc18355db12b5cbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d204f75195a30aad451d44efc64b1ff98e5d9713876cff4458865be3acd073bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db51dd6f15d86564a1d9a5758497d514b1328222c0635fa9b20ccc86b0a9716"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
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
