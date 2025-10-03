class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https://github.com/biojppm/rapidyaml"
  url "https://github.com/biojppm/rapidyaml/releases/download/v0.10.0/rapidyaml-0.10.0-src.tgz"
  sha256 "54eb1050789809a26c780f80857b7668a5b3123405d6514a65d733e4292c690b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a3acb1236b76e9252ecbf4d280e7f5637872fae07ce2bb422fd6e611b7234569"
    sha256 cellar: :any,                 arm64_sequoia: "39b6980bb79c269799dcbedad2067c9656293de5ee439d09779dd75a58cc1885"
    sha256 cellar: :any,                 arm64_sonoma:  "6b93cfe8b8ecffbb0efb0f90abb39b754d35a4ecec0e28840a0c8e77cab1b29d"
    sha256 cellar: :any,                 sonoma:        "f19b2606c78fe3f717e803758451d8e741503dab0edcd835a98c502c264f926c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "795add5af602f536a77fc2def8e10a83c5d62f4d90037a10a4536c76f1090981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe0da4e573557946d6960fc602f29d4ae3c26ae6b53d96abe618e9a6ca9ae8cf"
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
