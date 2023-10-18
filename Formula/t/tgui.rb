class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v1.0.0.tar.gz"
  sha256 "ceb3ad89308ae1b1e22bdcd6d476ff5b91b41d0449853d5644845de93d346088"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "81bfd5c282caf84cf7321d2d37a038d479a550a84e939a85165012f18c2f40d0"
    sha256 cellar: :any,                 arm64_ventura:  "e934a271a6dcf07ef29b7d53a50868a8441118737b387e87ca453d205455e84a"
    sha256 cellar: :any,                 arm64_monterey: "42cbf442654fb533cbdf77874f78af0cad3218e8c3d3ed52c9d5c835da35b4f4"
    sha256 cellar: :any,                 sonoma:         "ce2ccbc04743a8e54761949b1925ebb68569e4821bf89bda3c9451e85fab68af"
    sha256 cellar: :any,                 ventura:        "1136ffa8f4be75e8cea56c5b4ccc3f0fb1222251a29b734803a792ccd77cabe7"
    sha256 cellar: :any,                 monterey:       "6e992cf7649019c8cba59c2a7cd2bb691fec34b620170c5d7a9dd5d6be48a0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89b683ffa921aff7b7f7eb179b110811d72a62f7af0adbfb32091e85d1b91e8b"
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
