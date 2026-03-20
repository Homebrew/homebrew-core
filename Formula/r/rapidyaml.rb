class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https://github.com/biojppm/rapidyaml"
  url "https://github.com/biojppm/rapidyaml/releases/download/v0.11.0/rapidyaml-0.11.0-src.tgz"
  sha256 "46e42f656a767b9ecaf9b903b6f6a9c72453359ee9cbf488d510d0558ff5ab78"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6997e9d5a634aa37266f4186fc11137c886b63150113d710d65d88e500f96b67"
    sha256 cellar: :any,                 arm64_sequoia: "37d10c22e5a8061ef4bfb8c630ccf891324a6ba46ae37b7fde3b045da6bfe9d4"
    sha256 cellar: :any,                 arm64_sonoma:  "3662c6b0ee2c58622a6b1ab90e95746bd8f36f9342cba49999a8122dc66119c2"
    sha256 cellar: :any,                 sonoma:        "5c55f42efa974828fae3b6ed15fb0a3dbce40f2070b88a673bbcb35e509d4b73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f1e99898b0a319814216cdfed0fe6f862a11c6788a20df7b824e8b44cf10213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "000664809cba9de464a5ceb7c7d9b29a48c0ff43fd987bbc9380a120a85db0e7"
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
