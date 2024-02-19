class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v3.6.4.tar.gz"
  sha256 "7e93d5094a47180a3d451cb261ba29ac66f3f6ceb7c2a0884955e9a2bb06d818"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5d0e6ab34847ff5db7d8a903ed1285fa68dd79308616616e6a6633600e631ba4"
    sha256 cellar: :any,                 arm64_ventura:  "66e5b1519afabed659752f3fafc629653dd2fc14d5c2727e1a9eaf775cd22f33"
    sha256 cellar: :any,                 arm64_monterey: "c9a5dc20810b7aeec7e65d12ed12a20814bb50027822e44142cfcee350f3a92e"
    sha256 cellar: :any,                 sonoma:         "53270aab6da28138e8cbcf48fc5b67e05139ad4360d3c3c7ba781a04df69fbdd"
    sha256 cellar: :any,                 ventura:        "ce757dc1d7c118ae0d43c92c34d6934fb67a3defb00ef2345739e6745d1a392c"
    sha256 cellar: :any,                 monterey:       "ecd0e03efdce06995feaa7179f44af3d81990a1a327f1c9af7c0d6694b2beabe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29cc0c8a67019fb324dafa106bfdad81b36a7456da379d67b09a7fad59f22625"
  end

  depends_on "cmake" => :build

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
