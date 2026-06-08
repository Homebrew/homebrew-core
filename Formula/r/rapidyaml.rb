class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https://github.com/biojppm/rapidyaml"
  url "https://github.com/biojppm/rapidyaml/releases/download/v0.15.0/rapidyaml-0.15.0-src.tgz"
  sha256 "02b6f99c72315b8d20b1aa47f4e941e80069d9edd5bae4ba2fdf7e83d8f52d34"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "accdea4d1278cd42b890654db0e346cc054a027e21b5479cd8f375cbb5d13e49"
    sha256 cellar: :any, arm64_sequoia: "f223496f5fe07830469aef8439dba15093abbd171e612d96720b6b3fedc07534"
    sha256 cellar: :any, arm64_sonoma:  "dc2152109024145f0e98f748695037bea078eb51d74d937044e06439964b4d3a"
    sha256 cellar: :any, sonoma:        "41823362c98eb37a584ccec0ae970b030554fb9215448d6afc07a3372f241f5d"
    sha256 cellar: :any, arm64_linux:   "f875ca9f1d56231c26137032b7a1a3db70a211349fa713b888daa896907414a3"
    sha256 cellar: :any, x86_64_linux:  "1e8226461008a7b0f642a84a1b7badf94a5b1ef8775b2c4d384bfdfb07e19a81"
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
