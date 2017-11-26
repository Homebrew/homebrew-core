class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/0.7.6.tar.gz"
  sha256 "98ad67451e40dd7d9fed157802391738f9eb42a7c552c200161c0cb1aca40b02"

  bottle do
    cellar :any
    sha256 "0704075771f1b1a90a24a3f31f8892aa899fa2ead2b3b26f6518fe350c245933" => :high_sierra
    sha256 "897c59a552dc8dc164dc02be3da0c7b48d7f496b780eb8c397559d90ae734549" => :sierra
    sha256 "779e1add67f739fff76aaa5714d3110278e09192b7aa2bd9abdf7cc6de5eda50" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
