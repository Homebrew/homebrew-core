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
    sha256 cellar: :any,                 arm64_ventura:  "86a338b268c08838c1c081c3b90ea2aadc8f6bfe6554dc6eddc68bc93878a619"
    sha256 cellar: :any,                 arm64_monterey: "eb2010d067c45efd303bac411973243c0ff936c23b7da1c8a13b80ecf348e68c"
    sha256 cellar: :any,                 arm64_big_sur:  "102bfe8370777ea864c7e0c9713b02f36b72d2577119072b57b6140748c2af2a"
    sha256 cellar: :any,                 ventura:        "0ab40c9b44e333f064980bcc37b5b99573a1d373415cb3786f4d95a9d3696a82"
    sha256 cellar: :any,                 monterey:       "68dd6cdb933b8a1ae004b3213d4c1fbeb6069f0db396997a2aec5dcc2ed25dc8"
    sha256 cellar: :any,                 big_sur:        "df1f9591f00390b027cb6885c74fa7ae119c9984beadafe93a58bd81d3688f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2905eb9b4d3717295d134ee90c72811a5949ce6ba445801e1a17280e81e9238d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=11", *std_cmake_args
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
    system ENV.cxx, "-std=gnu++11", "-L#{lib}", "-lsystemc", "test.cpp"
    system "./a.out"
  end
end
