class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://accellera.org/"
  url "https://github.com/accellera-official/systemc/archive/refs/tags/2.3.4.tar.gz"
  sha256 "bfb309485a8ad35a08ee78827d1647a451ec5455767b25136e74522a6f41e0ea"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "eb785658f39fe25281c632a1e51daab687a0705730170884c4e997173d6125c5"
    sha256 cellar: :any,                 arm64_ventura:  "989d49220f52b3987baba507e649a30b4db40c1a8e9c55aef2678b47eb1672c0"
    sha256 cellar: :any,                 arm64_monterey: "689cae280d1d412ecf168b3b731b11433ad6dcbaa24b019d4949858922adf4f2"
    sha256 cellar: :any,                 sonoma:         "f352320837fc33c56ce5532f353192b2837b384ea9579f98553efc1757aebdc9"
    sha256 cellar: :any,                 ventura:        "c548bd356b7239e94e1a90fbbd4827dd344837e5326a0730d0f0b7fffe6f824e"
    sha256 cellar: :any,                 monterey:       "79ff38f4d5e532c70f095dee78f582b7d26c99ef220eecf358c7378ae925b249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f39ae4a52ab5bef51937c31c5237c3040438d889eb0ccda412cd259b38debd8"
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
