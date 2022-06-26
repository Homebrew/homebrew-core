class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.9.4.tar.gz"
  sha256 "08ce4893a5ab25a151be317c87395ac3567654547c9854b16c3142e750389cf6"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8cf63f4e1002f76b5a0a6691d2eb7a1bf6cc358e4c878815905c9ad2131e73d9"
    sha256 cellar: :any,                 arm64_big_sur:  "9088fcda97b4adeff261b57a4b7f9696d7617778da75a4e548da491e4ad1a8bc"
    sha256 cellar: :any,                 monterey:       "b0f45eecfd9bf712aa79880adce0a2cece1e48ac8599bb9e57cdabd5ccd165ce"
    sha256 cellar: :any,                 big_sur:        "37873670a0f0a3665560148ea67408aaad52bf36fdd54cc35a9c0e6babe3ff8a"
    sha256 cellar: :any,                 catalina:       "10d9ffc4baffa1206a56c62ca4f6c0968c83a1b3026b943e52596789c23c1cf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "899cd5ef7ce7e66f14487d1bad93990eaa45fe577cba4b203a2ad01de9b9c1ea"
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
