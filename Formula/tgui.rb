class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/0.7.1.tar.gz"
  sha256 "48ad3ce56a11ec4e3fdc370597d05c2921833f8a0f4d6ed9fcc1a772a0cd9a1c"

  bottle do
    cellar :any
    sha256 "d88822c09b3c9fa62e715ea85195895b7bcde852d00873241f2f52e207756176" => :el_capitan
    sha256 "6d77ff9accd5e3697c521903c8f434cab29f82353d0d61dbcb70809c837c3b64" => :yosemite
    sha256 "584391c814f3c27d4dfbb6da6eb1494b3972fe0c9c60ed7b4c055d55e66ab48d" => :mavericks
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
      "-L#{lib}", "-L#{HOMEBREW_PREFIX}/lib",
      "-ltgui", "-lsfml-graphics", "-lsfml-system", "-lsfml-window",
      "-o", "test"
    system "./test"
  end
end
