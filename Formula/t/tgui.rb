class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "c2f5aef8903fa613afabb20bcafae93cc5b1aef64d08b8d50c11433ec255732d"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0088efc49ed69c6cb3f69a49e7dfca751fdbe2afa5bcb06ef3ef1f8ec400d439"
    sha256 cellar: :any,                 arm64_ventura:  "762080fb7c531fb8e10a8f35a34132fbfc880f7c783945289ab2b103a5862814"
    sha256 cellar: :any,                 arm64_monterey: "e34f50267a3ff36e55579ff2abf85fdf40afdede2152a0b1ae310089ecbb9ef9"
    sha256 cellar: :any,                 sonoma:         "03d2a7de3ff5a4749bbcb9349d866e0d01c58e8095376227a180be67f94e60c8"
    sha256 cellar: :any,                 ventura:        "7aa89fa60f0b950d1ada9abb40f43c2b550f75066f92d513bdf7833b2f09de77"
    sha256 cellar: :any,                 monterey:       "4baf1c3fa41c78c7e319e4cfad28b2336f3192662a30468e560df0f30d515833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "979c86beb3d3c63f9d3693eb2ed517804680ac41174333090ef921dd0cc0a3db"
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
