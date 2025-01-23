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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "080aa369e3989af0d6356474269a0fbf23a87dca6004225a830b3d1ed35fd0d7"
    sha256 cellar: :any,                 arm64_sonoma:  "220cd61b22a0bc34084d3a0e0e3b37ee0e8e7b4cefe0c9cd2a3b6477d22b52eb"
    sha256 cellar: :any,                 arm64_ventura: "0ac91f25c61424cbac1b04aaea23a0180dbc0b2e276695271479e0af17323ac6"
    sha256 cellar: :any,                 sonoma:        "7f092bf4268f8503af9673cab2ebfaf3e36178dc4c630b06da9201eeaec9f551"
    sha256 cellar: :any,                 ventura:       "c92b6d820ea57fd04dad69efbd9d4a7a082cd8c0ae0e0a389e72540e6be2a667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29d9dfeb5710e057b851722005b8caf9752b04904115bde7044f51a8881bb706"
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

    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-I#{Formula["sfml"].opt_include}",
      "-L#{lib}", "-L#{Formula["sfml"].opt_lib}",
      "-ltgui", "-lsfml-graphics", "-lsfml-system", "-lsfml-window",
      "-o", "test"

    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "Failed to open X11 display", shell_output("./test 2>&1", 134)
    else
      system "./test"
    end
  end
end
