class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/0.7.1.tar.gz"
  sha256 "48ad3ce56a11ec4e3fdc370597d05c2921833f8a0f4d6ed9fcc1a772a0cd9a1c"

  bottle do
    cellar :any
    sha256 "fe0fa45f51adddf54945fe8297f80a1aaa8ace18cc596eb944ceb706e63ef591" => :el_capitan
    sha256 "cfa08d1293f85a7fa416a349da7aac6a901d0ba94ac5b381c19fb1fa79c67099" => :yosemite
    sha256 "7bd2d0c3da652852bdfbb928a293a22b85e85f6de3718507150a62d81e3c558c" => :mavericks
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
