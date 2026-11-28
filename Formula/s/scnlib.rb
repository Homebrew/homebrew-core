class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https://www.scnlib.dev/"
  url "https://github.com/eliaskosunen/scnlib/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "ece17b26840894cc57a7127138fe4540929adcb297524dec02c490c233ff46a7"
  license "Apache-2.0"
  revision 2
  compatibility_version 1
  head "https://github.com/eliaskosunen/scnlib.git", branch: "master"

  bottle do
    rebuild 1
    manifest_sha256 "b10e0c8887e57e5fe1d83a93bcfabbb03096609e72a39564162c611f429aab4f"
    sha256 cellar: :any, arm64_golden_gate: "90259d8ab7c91c9ac4d9607319865c62d1f90b717bbbd48956120e2e885bfce3"
    sha256 cellar: :any, arm64_tahoe:       "d65eaaf368f17b9a8f71ea12ea6cae05c03e7a43e8194e92f2581d6d2219d7ea"
    sha256 cellar: :any, arm64_sequoia:     "e84eb4515aafdfa12f9fb5f0e841391da9078c5c8d2c7efb8b5ee95a75cd11fc"
    sha256 cellar: :any, arm64_linux:       "3b46096c44c7b0c08bfa823e4b27f68fdf8ac26291afa2ade3b507d2175a4bc1"
    sha256 cellar: :any, x86_64_linux:      "b21a59627528f203d6ed974ace5e6b57048302213767fabb1d6808a3daf0db83"
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
