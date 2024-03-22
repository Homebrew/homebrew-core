class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https://scnlib.dev"
  url "https://github.com/eliaskosunen/scnlib/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "a485076b8710576cf05fbc086d39499d16804575c0660b0dfaeeaf7823660a17"
  license "Apache-2.0"
  revision 1
  head "https://github.com/eliaskosunen/scnlib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e0e820a21b0d5b709bfe633bb9423d8655cf7b55894ff0d0cb5b7a6078c91968"
    sha256 cellar: :any, arm64_ventura:  "090fe1a7c4bd431e2282c3cc6c6326db58c3e828315b77024b315842f657c753"
    sha256 cellar: :any, arm64_monterey: "43ef5a3b45568849dfcdba3f1d0772386cabdad807756771f4193f787b6a21c4"
    sha256 cellar: :any, sonoma:         "3e02537c9c2c1e290841a75d97b1bfcbcb8faf81663c941bab984efc24bd95bf"
    sha256 cellar: :any, ventura:        "0481b6aafbf8f5fa59f0ed88f4ac3ef8c8ef6b3389a00241961d16f580ce28ec"
    sha256 cellar: :any, monterey:       "1b034acf078d25518bf9ea25084d254d40e88397a5c68b61e3b183920eb18a6a"
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
