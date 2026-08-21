class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://systemc.org/overview/systemc/"
  url "https://github.com/accellera-official/systemc/archive/refs/tags/3.0.2.tar.gz"
  sha256 "9b3693ed286aab958b9e5d79bb0ad3bc523bbc46931100553275352038f4a0c4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "00716d64cbf73b299bc4196805922c068bad1b23a802eba56272e18bfcdfce65"
    sha256 cellar: :any, arm64_sequoia: "28d7da347948cd78f7193fbb099b257d8d3f946d07bc21742c7b7e690fbf5fe5"
    sha256 cellar: :any, arm64_sonoma:  "053cf8d14692e94ce4b21efad3d9ec03e881589e58906d0696aadbf41bce7c1e"
    sha256 cellar: :any, sonoma:        "20aa078e51eb304521647411756566b1bac49d85303c1bf47ce9c5c944298563"
    sha256 cellar: :any, arm64_linux:   "c206aedbe2c0bd668aa28cef896418cc1ecf2997a7ec303eb1d1aa3edeef25dc"
    sha256 cellar: :any, x86_64_linux:  "0eb26842c8208705f29dd7906859f3323de39cd358a6133ebee013837d892fdc"
  end

  depends_on "cmake" => :build

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
