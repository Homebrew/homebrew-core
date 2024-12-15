class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https://github.com/biojppm/rapidyaml"
  url "https://github.com/biojppm/rapidyaml/releases/download/v0.7.2/rapidyaml-0.7.2-src.tgz"
  sha256 "175b71074005a7d48ae03e973f1a7a5c104c588f193ba85044c5b4a97341aae0"

  depends_on "cmake" => :build

  conflicts_with "c4core", because: "both install `c4core`"

  def install
    system "cmake", ".", "-B", "builddir", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
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
