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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "dc21459f599692bc5af688bff211f25c18b2643375cba0fb19ee6dfe45ff3cfd"
    sha256 cellar: :any, arm64_tahoe:       "5baf47c3dae461e0cb08d37d049c432deabc74480efd9b59d79ca2726f3e573a"
    sha256 cellar: :any, arm64_sequoia:     "e306726a4cb13fad0b3e1c57bf7d26bd8b67e02e4dc0907616e2e39d80954ed2"
    sha256 cellar: :any, arm64_linux:       "5df2dee299a11cdb0b3bac9efe114da27b68b7a5fd59b5b368486da8ce01560e"
    sha256 cellar: :any, x86_64_linux:      "e8c59dd195dc02a9f3ba1c45f425155120101b97115cbd1dfdbbd44fd9f457fd"
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    # `gui-builder` is installed into pkgshare, so it needs its own rpath to lib
    args = %W[
      -DTGUI_MISC_INSTALL_PREFIX=#{pkgshare}
      -DTGUI_BACKEND=SFML_GRAPHICS
      -DTGUI_BUILD_FRAMEWORK=FALSE
      -DTGUI_BUILD_EXAMPLES=TRUE
      -DTGUI_BUILD_GUI_BUILDER=TRUE
      -DTGUI_BUILD_TESTS=FALSE
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: pkgshare/"gui-builder")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Opening a window crashes in the `brew test` sandbox, so only build the SFML backend example
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

    (testpath/"headless.cpp").write <<~CPP
      #include <TGUI/Base64.hpp>
      #include <TGUI/Color.hpp>
      #include <cstdint>
      #include <iostream>
      int main()
      {
        const tgui::Color color{"#FF8000"};
        const std::uint8_t data[] = {'H', 'o', 'm', 'e', 'b', 'r', 'e', 'w'};
        std::cout << static_cast<int>(color.getGreen()) << " " << tgui::base64Encode(data, sizeof(data)) << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "headless.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-ltgui", "-o", "headless"
    assert_equal "128 SG9tZWJyZXc=", shell_output("./headless").chomp
  end
end
