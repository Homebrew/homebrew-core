class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/0.7.4.tar.gz"
  sha256 "0f3710743c684e249cd147989d43efab80aae409879c21a738d9454995db8f61"

  bottle do
    cellar :any
    sha256 "6efb4a77d2e7176c15d010beb3691f1a18f763ca8e607c418e8a15c3fbd39f0b" => :sierra
    sha256 "9a024e5f5db23f4ba678af97bb6a725819f3c75c8938ac92501b83bbcf351823" => :el_capitan
    sha256 "18d29c8b221561209fc85110e7e5d73ec643b89efb68077f468be0e33c625382" => :yosemite
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
