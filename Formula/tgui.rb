class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/0.7.1.tar.gz"
  sha256 "48ad3ce56a11ec4e3fdc370597d05c2921833f8a0f4d6ed9fcc1a772a0cd9a1c"
  revision 1

  bottle do
    cellar :any
    sha256 "e127b6e58855cfad8b3f021b8dd064750f69d57abc8ae4103082ae0c73507f6c" => :sierra
    sha256 "7f23b1539f15402f31a753e73227595c2022a46783bdd1f486263b7238e70ac0" => :el_capitan
    sha256 "1a9bfb60a3766835e974a775a2e559c20a0b4231b5486f971235aea0aca37d67" => :yosemite
    sha256 "0ebb747dc89fdd3a1e14e83fe7ff55a9b6025a33f09e30ebe73a5be040f43eeb" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <TGUI/TGUI.hpp>
      int main()
      {
        sf::Text text;
        text.setString("Hello World");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-I#{include}",
      "-L#{lib}", "-L#{Formula["sfml"].opt_lib}",
      "-ltgui", "-lsfml-graphics", "-lsfml-system", "-lsfml-window",
      "-o", "test"
    system "./test"
  end
end
