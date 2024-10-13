class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "c9ee4dd9107a107bc818368691c607ab812fd8cf18d02effbe8a1413edea657f"
  license "Zlib"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ae653005a2c508f41fa97008f383ffb57b4ed00345975cda0fee9152201ae697"
    sha256 cellar: :any,                 arm64_sonoma:  "34c23d4a04975e6e8d01935219e0d4b86bf2eab913c7a1441b820717dab7ae62"
    sha256 cellar: :any,                 arm64_ventura: "22a69983852c4622aac5b2f668c02bae2f0f5ed9feff1a58876d0c56faac78c8"
    sha256 cellar: :any,                 sonoma:        "8a5abc027243e1e23838c4df10c22d0758efc1b335689922160dea25886390c3"
    sha256 cellar: :any,                 ventura:       "94f9406476600fcce70df6a413de54ecd2bee522bc6f8fca454b72540606e12f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c7863208e769e1080430365bd3993b2f2da5bd62176d308df8547f3f94024b0"
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
