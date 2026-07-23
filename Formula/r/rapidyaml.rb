class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https://github.com/biojppm/rapidyaml"
  url "https://github.com/biojppm/rapidyaml/releases/download/v0.16.0/rapidyaml.v0.16.0.src.tgz"
  sha256 "a0ce80a8f4211580c8703e57acb813a28ca6ec80908f6eb926be94be8e98d39d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3d2d310265fe2e85b26466170897f84e499feec516e72ef59a5c7d3025ca9f8f"
    sha256 cellar: :any, arm64_sequoia: "2172a17421b4d726e3f53491274f7c6439b29183d61046acb132572d9b391bd4"
    sha256 cellar: :any, arm64_sonoma:  "baae4c803d309361d8e7811cb0ccf6785da96c2c84dfead1f78a266560e58216"
    sha256 cellar: :any, sonoma:        "051cd90524844bb37544ffd782418a264f223ea03024b04fbcde6c93b29bb385"
    sha256 cellar: :any, arm64_linux:   "b5e10d4b571e69356e8597023f250a8a1925ac357fdebaba9feb12330b83a0e2"
    sha256 cellar: :any, x86_64_linux:  "d2811e4eeb4836d8e6a79891f4861759443aec576f34bca6e96de851f12e475d"
  end

  depends_on "cmake" => :build

  conflicts_with "c4core", because: "both install `c4core` files `include/c4`"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ryml.hpp>
      int main() {
        char yml_buf[] = "{foo: 1, bar: [2, 3], john: doe}";
        ryml::Tree tree = ryml::parse_in_place(yml_buf);
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lryml", "-o", "test"
    system "./test"
  end
end
