class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.9.4.tar.gz"
  sha256 "08ce4893a5ab25a151be317c87395ac3567654547c9854b16c3142e750389cf6"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e694ef23f7c331e9ade5da5ba872d66eb38b662b88643ffa10586d5816cd159a"
    sha256 cellar: :any,                 arm64_big_sur:  "5b7c153f39dc10454b182874e8d4ffd93e52d0c14de03912dce1643e17c3ad7a"
    sha256 cellar: :any,                 monterey:       "e07465d3dd63c15487ef251ff22e322e72d7c2f4f0eacf42514bfef7a5f7d708"
    sha256 cellar: :any,                 big_sur:        "0fda08ecd69619a0ea7ac101e9915698a3c439a677f5c1148834d585c51e5d12"
    sha256 cellar: :any,                 catalina:       "ba3b33488a47cfe5dedd377e0f3517feb0b052f1ee5a2d03ef92f469da6ba35a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1426f8179e7f14ef646875d610c511458bbf931c4f6f812d6c4f5ce4b3ab1e72"
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
