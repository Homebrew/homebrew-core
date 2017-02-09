class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/0.7.3.tar.gz"
  sha256 "1d71264420f0108e317e5e2a39fb6db559e1f0f897bcd62007c9b36cf0ceeb99"

  bottle do
    cellar :any
    sha256 "d1c89be0da213b401eb714f1431ecc63e7c604d2be71a64a07b7a5d0cdbc8315" => :sierra
    sha256 "ca13481dcec1a959a0be91e7674aa13449fc72277162466d257614967ef6dc48" => :el_capitan
    sha256 "ea357bbd9e0fe2f9e5ad5a71896fa337fa32e3001acae48d9b9ac490bf770200" => :yosemite
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
