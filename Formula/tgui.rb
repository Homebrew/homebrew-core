class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/0.7.6.tar.gz"
  sha256 "98ad67451e40dd7d9fed157802391738f9eb42a7c552c200161c0cb1aca40b02"

  bottle do
    cellar :any
    sha256 "274c934e35a52d4e8b5e3e33aceb41f4dd9069c16d208f746fc3785578c6962b" => :high_sierra
    sha256 "f9191f8d70ca5af003127115d863cc3e33493e16e911e2de4e4d65b8b0c1fa81" => :sierra
    sha256 "a0d4bdcca9e99fa2671356a3feacd666baee8bdf453cf20b5575cc88041949eb" => :el_capitan
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
