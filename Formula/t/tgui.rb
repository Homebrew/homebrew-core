class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "b25a5f8aca7823314e268118015aa14a8eb65956e09f447010230df10dc560b0"
  license "Zlib"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f6f46caab2a2b966f68e41d0bf192a6dba8fa0bc5b1d10f6bf45befd33587b28"
    sha256 cellar: :any,                 arm64_sonoma:  "5b9ac5c064671a3502e0379714e5d3e46b1ab0200c34cc3733f97b5d940327b1"
    sha256 cellar: :any,                 arm64_ventura: "65448ad581173ffa023bbca10808ba9adf50a1ffea0ea2b380a2463ec938b2e4"
    sha256 cellar: :any,                 sonoma:        "1a1129e84d3719786533488b8c53836c7a2a7d98e19a548515136ff77fefb689"
    sha256 cellar: :any,                 ventura:       "3dc2665391f4062de7f23e0e5ab573d3c3a0cbde3fdb011efcd2d5d1d350462f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05b2b8f955b300de27bd05acacb48a18a8bbbce384d778e06460dc73b5cde284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e347c7220989635107b88192baf013d465cdb8ca6e7e9ea218d4b1abe2e0f36"
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
