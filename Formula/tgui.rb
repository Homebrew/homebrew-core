class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.8.2.tar.gz"
  sha256 "084af94a20b3db1c44bcaa0a8c49628dfb90c1e83ff16471428ed4649be6d6a9"

  bottle do
    cellar :any
    sha256 "d0a3eedee9180952aae25221c99c9c995d38babc8f19cbb0299d0b8ec7a68a89" => :mojave
    sha256 "f5febcc39d2bc9cbebbdc3784e7dc6cc596a10641b7d163cccd94a08a9fc3578" => :high_sierra
    sha256 "0bef60a329c4677b438fd39de17fe22869ad2048c791487ce6d584b051df9f30" => :sierra
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
