class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https://www.scnlib.dev/"
  url "https://github.com/eliaskosunen/scnlib/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "ece17b26840894cc57a7127138fe4540929adcb297524dec02c490c233ff46a7"
  license "Apache-2.0"
  revision 2
  head "https://github.com/eliaskosunen/scnlib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3e180e76dc48748f90b00b0105e87716992ca66c2ad920d0ab009a1691bedf2f"
    sha256 cellar: :any, arm64_sequoia: "1b438140c8a4e9d36ef5c2352e3d12074c142a8e3482e903494cea8a8cf2ccbe"
    sha256 cellar: :any, arm64_sonoma:  "d36bbd09689058697115f4402fcecc172c5c3a0abcb96462fb0ea82a1899b020"
    sha256 cellar: :any, sonoma:        "83372097af15d6f124231a11517b83af153aeaea7942e1f589178b83a2e97fe5"
    sha256 cellar: :any, arm64_linux:   "937eb02bf741102204e46471e38bb13548515dd03ef7a87c06143deddfde264e"
    sha256 cellar: :any, x86_64_linux:  "5da43a80dcb3555e86bbc1e5dac081ad275282a7395e9e3bd082f08dfedf4fbd"
  end

  depends_on "cmake" => :build
  depends_on "simdutf"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DSCN_TESTS=OFF
      -DSCN_DOCS=OFF
      -DSCN_EXAMPLES=OFF
      -DSCN_BENCHMARKS=OFF
      -DSCN_BENCHMARKS_BUILDTIME=OFF
      -DSCN_BENCHMARKS_BINARYSIZE=OFF
      -DSCN_USE_EXTERNAL_SIMDUTF=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <scn/scan.h>
      #include <cstdlib>
      #include <string>

      int main()
      {
        constexpr int expected = 123456;
        auto [result] = scn::scan<int>(std::to_string(expected), "{}")->values();
        return result == expected ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lscn"
    system "./test"
  end
end
