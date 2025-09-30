class SfmlAT2 < Formula
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://www.sfml-dev.org/files/SFML-2.6.2-sources.zip"
  sha256 "19d6dbd9c901c74441d9888c13cb1399f614fe8993d59062a72cfbceb00fed04"
  license "Zlib"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b56c69d70b30eca4493fcd6ab9063a5f281cc3c82def8c43d55a63312372971"
    sha256 cellar: :any,                 arm64_sequoia: "7cb3afc70bc71a9a3c45edd4bf9ca54dc9514bc576a894f5f01d58c3b04e0b44"
    sha256 cellar: :any,                 arm64_sonoma:  "529996e0afcd2b27ad6c7f5e124067fb940d2c6c4b3dface4d21db5694c16b2e"
    sha256 cellar: :any,                 arm64_ventura: "8d76a3051365d997d2fcbe5b24c3042bb217df18f3f64d25bb0708875cdcbc91"
    sha256 cellar: :any,                 sonoma:        "96b5e8246f95125ed017da1a3b0ebf37ec9006c644efb2587d8e7e6d3fb4a5ec"
    sha256 cellar: :any,                 ventura:       "d7f41e0d4c78d3c6ecd487c9d8ba1f094ec42bf7dbddc3678bccc13e13091ed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de95401fa9357605881a1ff217dffa3c0fc7703968ce9f99ee25db3fb16fd2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83c161b5438b103ca014927de4b1ccba2782c9e6a654cce77e6041e02c91d1f3"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libvorbis"

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "openal-soft"
    depends_on "systemd"
  end

  def install
    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https://github.com/Homebrew/homebrew/pull/35279) but leave the
    # headers that were moved there in https://github.com/SFML/SFML/pull/795
    rm_r(Dir["extlibs/*"] - ["extlibs/headers"])

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DSFML_MISC_INSTALL_PREFIX=#{share}/SFML
      -DSFML_INSTALL_PKGCONFIG_FILES=TRUE
      -DSFML_BUILD_DOC=TRUE
    ]
    args << "-DSFML_USE_SYSTEM_DEPS=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "SFML/System/Time.hpp"
      int main() {
        sf::Time t1 = sf::milliseconds(10);
        return 0;
      }
    CPP

    system ENV.cxx, testpath/"test.cpp", "-I#{include}", "-L#{lib}", "-lsfml-system", "-o", "test"
    system "./test"
  end
end
