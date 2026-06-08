class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "70eb5ffcc203e53fb905fcc18a9974f80cdea3f2f4e59d8bcc1124d5d597c981"
  license "Zlib"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16887bdff35b75d7bef32b90539524a1383500870ec1418c5964fbb4f378eb13"
    sha256 cellar: :any,                 arm64_sequoia: "b410ee41f08763ea6e06e01f03f6dad5a79f78a48e57ce98bc82fa2d13b666b3"
    sha256 cellar: :any,                 arm64_sonoma:  "57ac7394cf1e1d8e1ac96cdd52db07e88abeb728c46a98db70715beb0c78f449"
    sha256 cellar: :any,                 sonoma:        "05639ca47bd0268d1ce5ae0579d37e7489282d63527a7354ab55ed2f8691b425"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e9c9a49822c85eb87f56710fba20e3e1f08205943b02c95676ea86d1f660e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b4cbc78761dca0ba65bda49b70a8b7fe12dcf852c9ccb00bef0a17e9739fec"
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
