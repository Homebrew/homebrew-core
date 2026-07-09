class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https://www.scnlib.dev/"
  url "https://github.com/eliaskosunen/scnlib/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "ece17b26840894cc57a7127138fe4540929adcb297524dec02c490c233ff46a7"
  license "Apache-2.0"
  revision 1
  head "https://github.com/eliaskosunen/scnlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21cd67cc5c419b781ebb8e1bcfed7f17c78dc0cb3db21be38aa862af5e1e4467"
    sha256 cellar: :any,                 arm64_sequoia: "134792df5a038f104e822bbe90a3df1e4a4c745c1c914f52375615910a26c5a7"
    sha256 cellar: :any,                 arm64_sonoma:  "a69e734225cbaf3294f549698798d4e9feab4c3d3e80afa4b90bba060fee12f3"
    sha256 cellar: :any,                 sonoma:        "3f0fc35c02be751f470426a42e2ff7f0b2ed80d2da7585dc62eb07a5905a6fa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b262e8c4395d69a9ce1c9e0dd08394614a0feeb865217f195c71e42ade0440c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24fbc7d2c410792aa8499dea07e901694b4dfe712f73fa40e6f09351c75fd6df"
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
