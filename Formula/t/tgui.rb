class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "7dcdb67353e9822fe7e79328ffe1ef3ca28e3a495c91f0536c8aeb250c8c0c4b"
  license "Zlib"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9de6a742a67b9060fe72d9fce6bbb5a0c7b9b36bb3b758d81b8654e9b632f96f"
    sha256 cellar: :any,                 arm64_sonoma:  "c59815ec11d8d68a337c19ec94ef57f31a26bb1abf3383cc32c5f4e30cb34a31"
    sha256 cellar: :any,                 arm64_ventura: "6140cd223e0cdc575fe6753846f3f9373802bff1d1bc8316b27d732e11d735ec"
    sha256 cellar: :any,                 sonoma:        "42b27869e89eda046f0af2c9a47b8df667dc76cfa1bf945c09cc598836f17442"
    sha256 cellar: :any,                 ventura:       "4574c8f7dcb63e4b8635100ec2e92b2738b48bf586675aed1f381c7a3bd53c1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77683c26c5a9f470456e5a2ce74f360255d4cf4af3f996ca2afc6564d1a092dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "834a0f6457dd8a66bd060b50c419da0d765fc292fab6679d250a14a404ffd894"
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
