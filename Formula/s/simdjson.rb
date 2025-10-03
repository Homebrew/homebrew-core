class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v4.0.7.tar.gz"
  sha256 "d2d15490605858d3dd42e90d25e0fde31c53446b7d3cde9ef334449236927916"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e1d7f98b560e026ccbf9ef734837b619d1af2eac6e13bf2f0732423271660f1e"
    sha256 cellar: :any,                 arm64_sequoia: "8474462783d068f9d841733101667cd2d66438a87c56264809a064be19ecd2dc"
    sha256 cellar: :any,                 arm64_sonoma:  "efc4c4ec1841704e75320815c1fcc6e33151c179e7fc0ea3d9053c39e2858455"
    sha256 cellar: :any,                 sonoma:        "a19a84d0b4cd38378280d0d1cf2407b90b933bdf70242fc2cc455e4561b6504f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd147fccc75f358859580be164fa881314c3a40a02234b1b784122154db76ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aff7b130042aee330962b712ca2b08c10f68e54d9382275a185c8c87e9a2ea6f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build"
    lib.install "build/libsimdjson.a"
  end

  test do
    (testpath/"test.json").write "{\"name\":\"Homebrew\",\"isNull\":null}"
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end
