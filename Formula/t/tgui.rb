class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "36389f3992681447b7ef7326954c3169f3fce901704eb8a4588c03d543380ddd"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d0bbc6f23e2b207bd88c56e9cbda1537ab9f3cb6c5a3534b386baf43d6fe8eda"
    sha256 cellar: :any,                 arm64_ventura:  "ffc7eefa11143e86f465b0d839abb0ae612485ad77e0e2c0e2b269741381ac30"
    sha256 cellar: :any,                 arm64_monterey: "edd07802af9ac9478e75ba6ac02ac229b2ed2d8946be258b3cbde92f033fe920"
    sha256 cellar: :any,                 sonoma:         "8438353b1be24e97f22518ccab0e2a087147e3935115fa85ad15fd084ae366f6"
    sha256 cellar: :any,                 ventura:        "cbefa5352b4adcb48c52f750123d9ef49c9c0d58883279f3f2c4a6fb6ffed1ac"
    sha256 cellar: :any,                 monterey:       "b129812318f1966a9740006ea1259c3fc42282c4bded324b73ad791dda8071ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04e3fde1d39a48d7b2f8bff810314bdfbb3caf64c28cf0983242965de5fdc00f"
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
