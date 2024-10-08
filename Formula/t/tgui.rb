class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "f405bc87174d8a781810c83223e07c048742b1ec7d0fd16bd32833e116654490"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "331c410afae43834b90cd3bb839372a0703a1ba2519828694d93e6e4173719ea"
    sha256 cellar: :any,                 arm64_sonoma:  "d1f06fe4bc9dd7c1d44dd1e5c77a9a61962913d7bf873d9c727ad1b16936e1ad"
    sha256 cellar: :any,                 arm64_ventura: "9bc3f9072df6bf1b2c7e72daedeaa82619eb7b4068b9232344362b30a6169e1c"
    sha256 cellar: :any,                 sonoma:        "4e93e653944bfafd353bc668bdec36e3d58d52e21220a5020a8547c7be970bd1"
    sha256 cellar: :any,                 ventura:       "5b8921bc9dab21a3ba1ec678d6944abd23bf599c9bf70d6280f744d71a8930e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e82936a0501104e046783f83bfc8664a4896a6e5a3a338fbc0ec9aee0b523cfd"
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
