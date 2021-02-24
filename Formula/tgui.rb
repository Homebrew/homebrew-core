class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.9.1.tar.gz"
  sha256 "6b08f14974be3ef843dacb6200efa39d1735dafac1f502fb604bb1f1de4d312d"
  license "Zlib"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b58a6d6ff3990f2afb85ea39073e00ce31d91c16d7c88c6c6f1c4f22c4f4f674"
    sha256 cellar: :any, big_sur:       "43215426baf657e7f73aa0751c3c952d35c489025065ed530223353d254c6556"
    sha256 cellar: :any, catalina:      "7e8a817332ba8a35526ee7dd0a499d4136780f54d905f4abd10fea287a185662"
    sha256 cellar: :any, mojave:        "4f003c5fc1520d427c657af818d88168cba1eeda04652a8cc016d10ef3214b23"
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
