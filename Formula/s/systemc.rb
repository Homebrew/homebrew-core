class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://accellera.org/"
  url "https://github.com/accellera-official/systemc/archive/refs/tags/3.0.0.tar.gz"
  sha256 "4d0ab814719cfd6b1d195dd4bcb1b9e6edc5881b9a3e44117336a691992bf779"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2740e733855c0ff23f257579f7dfd18457f6f3d24bc6a43bba6fd07ae051472a"
    sha256 cellar: :any,                 arm64_sonoma:   "cc59814681c92112b42bad9029facfd7142ee6b61d6000c10bc6d6d412aad0d8"
    sha256 cellar: :any,                 arm64_ventura:  "afb2a0c1006279804a2b73b4b2f38f085dd2931d11427ee773dfac5bd11bfe58"
    sha256 cellar: :any,                 arm64_monterey: "26d56ae7d9d1e3a9b1c9c14f023a26b0a2901b35ae48153783749d56ba9157bb"
    sha256 cellar: :any,                 sonoma:         "9510f8a6e4ae8e7b094af5a1ae26b4eb9eba7042f114c06efd3a354b204fe837"
    sha256 cellar: :any,                 ventura:        "56d56ea7f88e20e5092899f72798691e2d9ee3bbaa744442a0ebc197741765b9"
    sha256 cellar: :any,                 monterey:       "89cc5b92b23afd6cacc54a1f6d5d3ab77dd3bd8c7d8dd9c1c7e8044ad4880f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5feaf33ecf5d11ecc9d3458aa214cea38a694b5ac31eb4c5aa0d90e2d15ab794"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "systemc.h"

      int sc_main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cxx, "-std=gnu++17", "-L#{lib}", "-lsystemc", "test.cpp"
    system "./a.out"
  end
end
