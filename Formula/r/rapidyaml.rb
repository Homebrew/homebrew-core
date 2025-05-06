class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https://github.com/biojppm/rapidyaml"
  url "https://github.com/biojppm/rapidyaml/releases/download/v0.9.0/rapidyaml-0.9.0-src.tgz"
  sha256 "e01c66b21dfbe3d7382ecab3dfe7efcdc47a068cd25fcc8279e8f462f69c995d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a926b5137c4f63bb5ff171b5d7db7b5723ec241ca24151f01e94085796c5e2a5"
    sha256 cellar: :any,                 arm64_sonoma:  "eb19678c2ed14af83f23f00a5e290670a10879c10ff45801e758fffd9c710361"
    sha256 cellar: :any,                 arm64_ventura: "d38245d9b58586970547cadeddacdabc64aba97364605fec1818043e7b74b680"
    sha256 cellar: :any,                 sonoma:        "53a6ed410c614d69717df813c05e0874aef7b1ddec62faee50dbb10dd7f92158"
    sha256 cellar: :any,                 ventura:       "59eede95d14fba8e567d1c3101b30a1dc474038eba06159805caadc2813ed927"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6af592cde3cde4adc1af59e80dde10d048d7af6108ec34aeb21f9c4c5ead41a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4b2a7dae11ce18a1dbe21856222bde0585ab5a96b08349d94741805ff74bd6a"
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
