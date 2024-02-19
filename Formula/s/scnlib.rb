class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https://scnlib.dev"
  url "https://github.com/eliaskosunen/scnlib/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "f399d1b1f36f5d53a2d63fd2974797ab8f3f7e69c424d9661253830cb793b72e"
  license "Apache-2.0"
  head "https://github.com/eliaskosunen/scnlib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e22bea36ae91b2f43385c0b0d43e9b77c9a116879379c194cd97c149a7e9132d"
    sha256 cellar: :any, arm64_ventura:  "4ce93dcd2893a84cf01a334a08c664e39cbfeb12d3beefa8ffa5da82d384af70"
    sha256 cellar: :any, arm64_monterey: "850fee376866830273c9cb4331b6b0b76c4706f2324cf14a1fc80ede1d5e1376"
    sha256 cellar: :any, sonoma:         "ce57c37c1750a47a47841a7bee1d1b402776dac68d9231543eb35ec25046dc27"
    sha256 cellar: :any, ventura:        "ae1baf906ecb7837e529e844f3b8a79331bc54ea11bb81d11f59da15dea58919"
    sha256 cellar: :any, monterey:       "ccfd04d6c7bd523f5b47c24488b36e237dc2bbf8418d283fdc32e53ae3d64d94"
  end

  depends_on "cmake" => :build
  depends_on "simdutf"

  def install
    system "cmake", "-S", ".",
                    "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DSCN_TESTS=OFF",
                    "-DSCN_DOCS=OFF",
                    "-DSCN_EXAMPLES=OFF",
                    "-DSCN_BENCHMARKS=OFF",
                    "-DSCN_BENCHMARKS_BUILDTIME=OFF",
                    "-DSCN_BENCHMARKS_BINARYSIZE=OFF",
                    "-DSCN_USE_EXTERNAL_SIMDUTF=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <scn/scan.h>
      #include <cstdlib>
      #include <string>

      int main()
      {
        constexpr int expected = 123456;
        auto [result] = scn::scan<int>(std::to_string(expected), "{}")->values();
        return result == expected ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    system ENV.cxx, "-std=c++17",
                    "test.cpp",
                    "-o", "test",
                    "-I#{include}",
                    "-L#{lib}",
                    "-lscn"
    system "./test"
  end
end
