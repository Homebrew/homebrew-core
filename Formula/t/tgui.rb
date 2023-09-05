class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.9.5.tar.gz"
  sha256 "819865bf13661050161bce1e1ad68530a1f234becd3358c96d8701ea4e76bcc1"
  license "Zlib"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b760089e9901e780346faeda6d680ebc3d752f54a6a46d4c782872f08ce5c9fb"
    sha256 cellar: :any,                 arm64_monterey: "8a2456389f6a9a9ca380736525d059ac91aa46eb2d4fc15484a25347a9df6c6f"
    sha256 cellar: :any,                 arm64_big_sur:  "895ca27d73fbefeb0a8aa3549544a5ffd37bf12b3e644614674621201b40f321"
    sha256 cellar: :any,                 ventura:        "2c405311a5faf7e09c44220a4d597f51814fd94473a19eacb686d8a45fc55afb"
    sha256 cellar: :any,                 monterey:       "d283a951bca2b60726ea2b3eaf6e4ee7be0454f577402c1db8b86d6624a0bd8d"
    sha256 cellar: :any,                 big_sur:        "a0576cdb65a60167ae19063c933983e7fae19bb1f98307f5e790fe885dfbe429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f36bca7449191ceb14c4ff91f34e34712ed8d9128eb0fe40abaa0d3bea69e944"
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    args = %W[
      -DTGUI_MISC_INSTALL_PREFIX=#{pkgshare}
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
