class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.8.3.tar.gz"
  sha256 "d5bb9e0923a613f9757a65155796e065587c4248c7c41341b926e85f4a6f5aee"

  bottle do
    cellar :any
    sha256 "cb952ffe75c43aa8a6e32f9afd29ffdb03ac4f7daf18aedffae6d1fd50efd565" => :mojave
    sha256 "389383174540662c0c1ea404bc60274e18b4615aa19bcc13b65ba35dae016119" => :high_sierra
    sha256 "5601231201ad9ead3679d182c41354619c5f225de8e027ba46ac54930b16c882" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DTGUI_MISC_INSTALL_PREFIX=#{pkgshare}"
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
