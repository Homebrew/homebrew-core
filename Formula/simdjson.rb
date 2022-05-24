class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v1.1.0.tar.gz"
  sha256 "9effcb21fe48e4bcc9b96031e60c3911c58aa656ad8c78212d269c0db9e0133e"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f2e9edbd04fb5a138a642472fcfcf8a6ade530b2fb2fefa4b42f7d0ed3a1b44b"
    sha256 cellar: :any,                 arm64_big_sur:  "9d202674c9cdd89243d7b33cb702993cf35807ba3f3322dfb95a2c5875656460"
    sha256 cellar: :any,                 monterey:       "8929e292d50dafbe24d623ac686039202b5594b26f35cf175578ff1be3a14902"
    sha256 cellar: :any,                 big_sur:        "4a37c01e7298d765fd92da44cf69030459974a565f38c84a81323920a2ca7653"
    sha256 cellar: :any,                 catalina:       "7c33fdb53d9a8e07c42efa654ceb95bb8ae51024b8ff249fd45979cd71da2a0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fb8f83993f56ac81d7a330a64e11ea12cae3de3ef53ef136c38ffc669098cf3"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end
