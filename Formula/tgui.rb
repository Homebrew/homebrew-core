class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/0.7.4.tar.gz"
  sha256 "0f3710743c684e249cd147989d43efab80aae409879c21a738d9454995db8f61"

  bottle do
    cellar :any
    sha256 "ef8653f1d88eec97730b09eb0361829fd54e646d4bc8e6a0c82a7890a67504fd" => :sierra
    sha256 "22dbb10255cfed794b5b2ead488df87603f0f9853b593b21757022c6a9a447c7" => :el_capitan
    sha256 "4c4eeec50f48d7178ea68de0769e114ca316cea27704ca68d1975319412c8689" => :yosemite
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
