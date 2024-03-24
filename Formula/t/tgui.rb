class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "c2f5aef8903fa613afabb20bcafae93cc5b1aef64d08b8d50c11433ec255732d"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d12b1e5e7687946d49b49793b46352dfc7754896f2e5510498215fac793609d6"
    sha256 cellar: :any,                 arm64_ventura:  "f857cde17a18df35cacf11906fad0414d7602a0d964535159f939e9d307d76ac"
    sha256 cellar: :any,                 arm64_monterey: "c4499214db50da0ffafefa7c5f7bb0b749bd794303ff8f3d6691ad82bb88bca0"
    sha256 cellar: :any,                 sonoma:         "5b9c1f848b760beebffd3afc8834aeae169a9cdf30943589628fd13a8bb2584b"
    sha256 cellar: :any,                 ventura:        "af19e9f20db8096656ba4bd4f4fd4f3797920f0fa99c5c2486360ee1ee6537d2"
    sha256 cellar: :any,                 monterey:       "3899149da693d2bb9eda610b2c87c2390dafcc2c5b84df198b0fb89992d71e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34ef656442a372a5d4abe9c8cf8fc04e3954611449be9dbb22e833347764c3d7"
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
