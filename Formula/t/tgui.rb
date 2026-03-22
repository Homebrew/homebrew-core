class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "dcfb87fd2684a90fd443630ef4ca7003bfcc39a8f0efab3584a4086f10b8edf5"
  license "Zlib"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98ec10e665478f0699adcfaa95a62b9624cbd7d403294302ae438dd0e5ce5a99"
    sha256 cellar: :any,                 arm64_sequoia: "0e9b6dec3b5797bf32cfabd25b9517a302dd888cf4b9a0b8389b50c97f443103"
    sha256 cellar: :any,                 arm64_sonoma:  "bbc51df5968fc602fb34750b5c57e983f1430a64f16f45b8430ca706b92f3ab7"
    sha256 cellar: :any,                 sonoma:        "a49e7cf99000621cb9ff3a9a6b374abddd9f97cde29832545c41c97fd8e4e588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d47f965e59c666e4b00ab940f04f0bceb3a98641018a7e194d47605cece0939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5ef4bcabc24339dd42e54cc960a57ee498336a930b2b8aa54c626aaf6450080"
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
