class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https://github.com/biojppm/rapidyaml"
  url "https://github.com/biojppm/rapidyaml/releases/download/v0.7.2/rapidyaml-0.7.2-src.tgz"
  sha256 "175b71074005a7d48ae03e973f1a7a5c104c588f193ba85044c5b4a97341aae0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bed20b676b6e5e438347f920c4ee52f9b8690e33ecafdcdbc7cf31b147db691e"
    sha256 cellar: :any,                 arm64_sonoma:  "8b9c7096e0cd01edd2b36cdbe6889062137862941df260698b320cdb54f57286"
    sha256 cellar: :any,                 arm64_ventura: "5b026d039db10c29eb9658b555904ff8df6f2065d5824273626e23306402dc7f"
    sha256 cellar: :any,                 sonoma:        "b442c77ff0044171081f73c28a7964ec2773ac913f8e49c6bb4c9d3e70ac2a9b"
    sha256 cellar: :any,                 ventura:       "b2c36f5eaf706fd6195cbb2a33ad1fad2b93cb1877449e2ecf10fcb627b4239e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e25635ec621c1d6913c10b1303e0fa46d25a34a79d216eaab89a145748fc9f8"
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
