class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "6e6000b5b130d6ddf73d593ff62cdd6f5c2045a1f8ffacb10262aedcb7ea7465"
  license "Zlib"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ac9ad29abf0f6a3cccd59a5cf2243a43aa358371d599d766be6ad33eae76392f"
    sha256 cellar: :any, arm64_sequoia: "86a3bdd39b884ecb48cdb543c6ec730de37613ce5c8faa9d6609e60d66d68982"
    sha256 cellar: :any, arm64_sonoma:  "01ea5a223bff9f443a33d5bfb39e95de15b617e018551c74f3cd0e586c4802f3"
    sha256 cellar: :any, sonoma:        "8c3f0e9603581ab53438679d6d286e234a07695dad2cdd29b5578889f2c5347a"
    sha256 cellar: :any, arm64_linux:   "cff015f7071d445fd1564c061d080f5a101ecede8b371eb506e0e4b18b937da3"
    sha256 cellar: :any, x86_64_linux:  "de466c0cec114b5970e36674792036bf700eda325ed4129763f56bf0cb7a6322"
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
    (testpath/"test.cpp").write <<~CPP
      #include <TGUI/TGUI.hpp>
      #include <TGUI/Backend/SFML-Graphics.hpp>
      int main()
      {
        sf::RenderWindow window{sf::VideoMode{{800, 600}}, "TGUI example (SFML-Graphics)"};
        tgui::Gui gui{window};
        if (!window.isOpen())
          return 1;
        const auto event = window.pollEvent();
        window.close();
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-I#{formula_opt_include("sfml")}",
      "-L#{lib}", "-L#{formula_opt_lib("sfml")}",
      "-ltgui", "-lsfml-graphics", "-lsfml-system", "-lsfml-window",
      "-o", "test"

    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "Failed to open X11 display", shell_output("./test 2>&1", 134)
    else
      system "./test"
    end
  end
end
