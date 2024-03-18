class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https://scnlib.dev"
  url "https://github.com/eliaskosunen/scnlib/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "a485076b8710576cf05fbc086d39499d16804575c0660b0dfaeeaf7823660a17"
  license "Apache-2.0"
  revision 1
  head "https://github.com/eliaskosunen/scnlib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "baf89836b5d0fbbf9c4a4eec7b12600eb583d692150724145bfb2576b5db7775"
    sha256 cellar: :any, arm64_ventura:  "dd2bbeaad476dbbe0e95eaf57f3c8f16236ba2ed5657a44eda4b5e4f1af471df"
    sha256 cellar: :any, arm64_monterey: "9ea820cb1ee60c2cab7f18f573233a85793dff8bf08da54a2979198f990082b1"
    sha256 cellar: :any, sonoma:         "2d05fb5c4c3ffa616c6840747880dda74dcf4a5ffa58262f8e6a24157e7fe387"
    sha256 cellar: :any, ventura:        "c6540655c54874634e739131ec3ea3a6a374fcfd4b97d498bcf0078992e9ee56"
    sha256 cellar: :any, monterey:       "cbfcf415e9c5fa140c32344d4220471ef5e65101e713fec8aeaa35320bf4eb63"
  end

  depends_on "cmake" => :build
  depends_on "simdutf"

  # patch to support simdutf 5.0.0, https://github.com/eliaskosunen/scnlib/pull/102
  patch do
    url "https://github.com/eliaskosunen/scnlib/commit/5398f91aa42f5bc88bab00447e51ad0eab65300d.patch?full_index=1"
    sha256 "43d2f868589515d7369ce35d5a9700f17275a54b670b6928c6be344735c1ae9b"
  end

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
