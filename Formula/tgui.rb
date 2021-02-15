class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.9.1.tar.gz"
  sha256 "6b08f14974be3ef843dacb6200efa39d1735dafac1f502fb604bb1f1de4d312d"
  license "Zlib"

  bottle do
    sha256 cellar: :any, big_sur:  "276bab3562779025e99490619c9ac595bf9ca05e0c831fee1ce2bda07fa7d737"
    sha256 cellar: :any, catalina: "0cfe1001dee147da83e57643d59ff70f7debd5b2dd930747c46af99e1081be43"
    sha256 cellar: :any, mojave:   "ae8196c6817e0efa34204da77f5edd1ca17f50c9385b43946e4737640c0f25d8"
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DTGUI_MISC_INSTALL_PREFIX=#{pkgshare}",
                    "-DTGUI_BUILD_FRAMEWORK=FALSE",
                    "-DTGUI_BUILD_EXAMPLES=TRUE",
                    "-DTGUI_BUILD_GUI_BUILDER=TRUE",
                    "-DTGUI_BUILD_TESTS=FALSE"
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
