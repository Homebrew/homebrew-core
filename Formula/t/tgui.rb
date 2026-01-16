class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "096e1183137a9e3e8f2f3d2fc65ff6355e938ffa7383dce0e51e06885abe7e61"
  license "Zlib"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "86614489998a70a5dc860c8364a5507e5cd042d99b84e788cecfdbd378de9bac"
    sha256 cellar: :any,                 arm64_sequoia: "6bd9dca615dd65cd0f668566bcd5aca4806d1bc4e9c2be96104f724523452047"
    sha256 cellar: :any,                 arm64_sonoma:  "d835948113282163393ba26748b51ca96d3335387b06ed984a9641950ac1d2db"
    sha256 cellar: :any,                 sonoma:        "07c98ea2048d0ba71e18e9036d9bd5e098de1320d0699105b2ad047c31d5e9f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ebe73db411a2707b600090dd1d2e0886dc5108d26c04c89117309fa7c6ee56a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c8ddfdbefda92eab2364d8eff35f12eb1973c0cd758c29e6bb8dfa1df357eff"
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
