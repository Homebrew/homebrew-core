class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https://scnlib.dev"
  url "https://github.com/eliaskosunen/scnlib/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "bc8a668873601d00cce6841c2d0f2c93f836f63f0fbc77997834dea12e951eb1"
  license "Apache-2.0"
  head "https://github.com/eliaskosunen/scnlib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "d4c3012cf46e5a7bc4fb57004aec3032f9225d2633811f9236990d203f91287e"
    sha256 cellar: :any, arm64_sonoma:   "def3883afe16f2e32c65d6f9331aa050124e602abdc35a20bd88d6beafb668c0"
    sha256 cellar: :any, arm64_ventura:  "00ed2164ad8e23214486727d7fa9ef9cbe3bcaaa15f9c273df7b90e1be7fbed3"
    sha256 cellar: :any, arm64_monterey: "121ad95a6e8d037dfb926d43ae88e5621592ca39a444dab497833e6535e4957f"
    sha256 cellar: :any, sonoma:         "a1ae7d4535296341082febf3ccae1e3cff7f218687642428c2029e6ae06fcf97"
    sha256 cellar: :any, ventura:        "91a8f6f2cad11299e504249add90dda7c3ee47f37b0fc07a769153e3a343e445"
    sha256 cellar: :any, monterey:       "a8890b190420eb0ddfdf11b464719d5f51fff232b62c79060ce29b877e759af1"
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

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lscn"
    system "./test"
  end
end
