class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "641067026656518479ac8e7e1551fc0673836dfdb82c31b03474c27eb3bf0b05"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e839f1b5b9945f0cd2737ea93e624fb0fc8f8308edf843719fe923d6d8407082"
    sha256 cellar: :any,                 arm64_ventura:  "98d5e03611ff45bf440c7c12fcdbc61b93e08c4048932129e997491968d631c4"
    sha256 cellar: :any,                 arm64_monterey: "0d78d86653592784e30142a35538ee6dade97db3da361e2b2352cca20f49aab9"
    sha256 cellar: :any,                 sonoma:         "27b8e682819b001faf77a266e39e7dfc8d87f4728d2e761e8bdab86f4372e4e2"
    sha256 cellar: :any,                 ventura:        "b9bea58c715494b1cd62aca8ca705f0e4d51a6b0c395d0ba407f014af456270b"
    sha256 cellar: :any,                 monterey:       "109dce3263f806ea1129b04c8c08870a7d652d123cf2f25d8b7054b1d6cf79af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e6230a051dcb356576ce2c233168e67d13337326242af20a2d4d77d102f5c64"
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    args = %W[
      -DTGUI_MISC_INSTALL_PREFIX=#{pkgshare}
      -DTGUI_BACKEND=SFML_GRAPHICS
      -DTGUI_BUILD_FRAMEWORK=FALSE
      -DTGUI_BUILD_EXAMPLES=TRUE
      -DTGUI_BUILD_GUI_BUILDER=TRUE
      -DTGUI_BUILD_TESTS=FALSE
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <TGUI/TGUI.hpp>
      #include <TGUI/Backend/SFML-Graphics.hpp>
      int main()
      {
        sf::Text text;
        text.setString("Hello World");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}",
      "-L#{lib}", "-L#{Formula["sfml"].opt_lib}",
      "-ltgui", "-lsfml-graphics", "-lsfml-system", "-lsfml-window",
      "-o", "test"
    system "./test"
  end
end
