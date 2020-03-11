class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.8.7.tar.gz"
  sha256 "3e49f161f624ebe91711cc0fb2d16fc47939e03725e79e16a57e60219eac84a7"

  bottle do
    cellar :any
    sha256 "2915a3f1a9ea5911aa740862361c4b5947c62e673dfd38ae6916821bdb39b63c" => :catalina
    sha256 "bb4cb1abbe054e3a6111a1b6c6f94542dda6de5ed2a090b5089f1b7248d04aad" => :mojave
    sha256 "811a11b144eaf8cd53701b61529cfe3429f5d2b25846ff861318375c180f10af" => :high_sierra
    sha256 "28ccab66f83240703d4778a408576be56b1a212c520419b35bc9330c70ea5cee" => :sierra
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
