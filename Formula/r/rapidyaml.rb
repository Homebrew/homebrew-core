class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https://github.com/biojppm/rapidyaml"
  url "https://github.com/biojppm/rapidyaml/releases/download/v0.11.1/rapidyaml-0.11.1-src.tgz"
  sha256 "9d9938269adc25e9a9b84650338b87d130cf469d82685fffc028c325279619c1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9582f8355adaa95cd7c9f47f13d2daee0bcaa704d1554575d48ad7b7013bf3ac"
    sha256 cellar: :any,                 arm64_sequoia: "ca7aaccf4437919f82eeae974e66be5b732e39128aaf52021f133be060ba87c5"
    sha256 cellar: :any,                 arm64_sonoma:  "dd64910f09873586ee987a76ce3e6a0c2b3f07d826844e0d76133ea6d9a7a5b4"
    sha256 cellar: :any,                 sonoma:        "b296626c23d782325167163b5ba05db22ae1b327967f74ea7e1a16353d8af2e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a642e51102e5fa9f6d3fff6074055d9a94e822d11a90ce2c5c201138cdf0b002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f29a0168ef5dec7225e4c5d6a433802e20777fe347ba6ae1b8dbedbcb961f72d"
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
