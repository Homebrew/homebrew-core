class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https://github.com/biojppm/rapidyaml"
  url "https://github.com/biojppm/rapidyaml/releases/download/v0.12.1/rapidyaml-0.12.1-src.tgz"
  sha256 "e9efcdd17f86287748793cf21d106e461fcad8d103a3e5a23632afe93828660d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27c328feee0cf8d7335615093c0cafd158f5d362c4ea4d797811e639681c4882"
    sha256 cellar: :any,                 arm64_sequoia: "6dd5d1cc3a4c5f690ca4d36f2aeeca42c0716a5e0cb17b64b735a99fd6201730"
    sha256 cellar: :any,                 arm64_sonoma:  "ccb1d9bb612ab635f812785c88e0f48d741589f0daafa2bb78a01612245a542c"
    sha256 cellar: :any,                 sonoma:        "7adad1b67964edd26bad65a7fccd95c7e09be7538ca9bfd23154c8c921772d60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3e4be74dfaa82105f06e46f606742582c1d0cbbc9d061be07874f7297c0fb69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9c01402a502115f08eb04efe48ef4db26cb0838a295f45ff7d3e5cb14c19af7"
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
