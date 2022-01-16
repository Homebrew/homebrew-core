class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.9.3.tar.gz"
  sha256 "187acfa850e24e3676e656a7dbe53736c98ca2577d756e9c96c9dad6374ffa0e"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a2dc6b2beeb76f9a4113c4c30e2c4bc7d1dfe3b98be347b8a53c29c230fc4aef"
    sha256 cellar: :any,                 arm64_big_sur:  "e65da29f16e52a57c59fda7ccb42406476a7d18e9307d50f900aa97b583b5cd6"
    sha256 cellar: :any,                 monterey:       "dfacffada3a7a402771586f74122028d6cf61046d80f235606e26d4b1114f97f"
    sha256 cellar: :any,                 big_sur:        "0ae12484aca4b34565c55412f7eb601b172bacc21d5cbbedc78f62125b11ce11"
    sha256 cellar: :any,                 catalina:       "2c8c3c3fa053c604ac358b46723b4b70dfd6fdfa58788f8b1e262de62c869411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0024c287753382190541a4184da147a56990ce911eb82e91e7a7f84c15ce8de5"
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
