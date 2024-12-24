class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "7d40359770e2f8e534a57332c99fd56c72cf79a8b59642676e01394fe05cb1fa"
  license "Zlib"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "90d6c28e6b997ca35cdff3fec9d975cb13fabb8d5414d5d3df099017d40178b7"
    sha256 cellar: :any,                 arm64_sonoma:  "6788040409873afe34bef9f3c78af753967452644ea81a4b639078a6b803c9d5"
    sha256 cellar: :any,                 arm64_ventura: "8c7f17dc0db7ef819fddc51958ed586c9713a1731933af201c43a20a9d137814"
    sha256 cellar: :any,                 sonoma:        "d116111ee1c1d2b1bcdf3156c0537999ddf6a02ef5a1bd36c01e0c95b59666c5"
    sha256 cellar: :any,                 ventura:       "15f48330201de8009cb8f79c6d0be0a2bea00d0a0cd21dffb6f77c133297b4b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adb09f2ae11fe708c1b9fda03590f2483f490535d9e6572778e10f3996df45a3"
  end

  depends_on "cmake" => :build
  depends_on "sfml@2" # sfml 3.0 build issue report, https://github.com/texus/TGUI/issues/249

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
    (testpath/"test.cpp").write <<~CPP
      #include <TGUI/TGUI.hpp>
      #include <TGUI/Backend/SFML-Graphics.hpp>
      int main()
      {
        sf::Text text;
        text.setString("Hello World");
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}",
      "-L#{lib}", "-L#{Formula["sfml"].opt_lib}",
      "-ltgui", "-lsfml-graphics", "-lsfml-system", "-lsfml-window",
      "-o", "test"
    system "./test"
  end
end
