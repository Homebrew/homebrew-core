class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "d2e56ac67972d4345b4fddeae6751e86819e886097d33c6e93f6809efaae70e2"
  license "Zlib"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15ff78d8c464055c7944dc3d57c41c01789ba87ed9458909ef7a135690d526a0"
    sha256 cellar: :any,                 arm64_sonoma:  "2299e5b4b46b72e25a2cca5b39a5be0ae48a1ee5360f905212b258457aad6789"
    sha256 cellar: :any,                 arm64_ventura: "692587abd04e2d5269df879e6d2f53b72269e7a940560318f801dbd5cdbe806c"
    sha256 cellar: :any,                 sonoma:        "3d01c3459b2750d8e0a2550930712b88889c0513b6cddd25fa3344903118f03d"
    sha256 cellar: :any,                 ventura:       "ed77565acba8b915bd61752d6dfa5c59662d357d35d7b34155f98d26a1f50ae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fb31a0cb2b419b56ac63403b6b2868a08e72e85e0d0d4fbfb27f8fff35f5db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "464b4d2c59774b1aac1661da43a28d3c12e7e894eb5a8f4d6b2c8ba9b12092b0"
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
