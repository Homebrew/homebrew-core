class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.9.5.tar.gz"
  sha256 "819865bf13661050161bce1e1ad68530a1f234becd3358c96d8701ea4e76bcc1"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "58265fe49f8d2e4aeb31469b53775f020c2d335ccb0499ac423a612b57312328"
    sha256 cellar: :any,                 arm64_monterey: "b9df36b637acb021e6a48820d3bfc8fd8921ce2bc6e1098cbfe0020481bafdb3"
    sha256 cellar: :any,                 arm64_big_sur:  "fc9b9d68d0eb79c88f04a936c4e2bb28c76ecf70aeadb8eb4d0397f15bf03337"
    sha256 cellar: :any,                 ventura:        "b3563f9ab78cf4b330bc0e3a2c9b3484c9acdcceb44b18864a91325f90e8e4e2"
    sha256 cellar: :any,                 monterey:       "ae814b6976689b902356e4aad9ded09431ca45ba37ab33283a4c2156591e61d9"
    sha256 cellar: :any,                 big_sur:        "4295dbcf07ac7e2b2c3253823ea1743252db212ee81f5feddbf8ff1c14183ff1"
    sha256 cellar: :any,                 catalina:       "bf8e0820e7909e78a7c758ba3fc745dd2b3dd1e226451a855d90b642fdf26b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bce36f7002bb1e2c81842cd7c683d3a5678b22f18ab8ab6636e97836ae4270d"
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    args = std_cmake_args + %W[
      -DTGUI_MISC_INSTALL_PREFIX=#{pkgshare}
      -DTGUI_BUILD_FRAMEWORK=FALSE
      -DTGUI_BUILD_EXAMPLES=TRUE
      -DTGUI_BUILD_GUI_BUILDER=TRUE
      -DTGUI_BUILD_TESTS=FALSE
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", ".", *args
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
