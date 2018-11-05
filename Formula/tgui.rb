class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.8.1.tar.gz"
  sha256 "fa0ff806b9b5c4a0dbc79f6ecdc814415720be47a4ab5e876c189bc1ee896651"

  bottle do
    cellar :any
    sha256 "94d065332acd72cc9485c80840437fb468927f6adb6b73396cb7af5d9444c65b" => :mojave
    sha256 "505b1961019363f47c484c68cdd1a4f4f8afec17da0554fc2337f416ceccec59" => :high_sierra
    sha256 "ca91de08aa2be36182cf9ee7ff888c88ef8d9c4b3e0d9e52740d315b068e5d9f" => :sierra
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
