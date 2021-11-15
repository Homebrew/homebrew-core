class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://www.sfml-dev.org/files/SFML-2.5.1-sources.zip"
  sha256 "bf1e0643acb92369b24572b703473af60bac82caf5af61e77c063b779471bb7f"
  license "Zlib"
  revision 1
  head "https://github.com/SFML/SFML.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "1c47115d6352b6c60d3d99630532107ee64aa55d1e4f0c0e4cb5da969c6e99fb"
    sha256 cellar: :any,                 arm64_big_sur:  "ef472896cd55333ffe21c531b3edb055e487f5a675174feacfa6e02269877a6d"
    sha256 cellar: :any,                 monterey:       "62789446ecdd1939ae40c7a793c5089d44a945245b7169c66c0423e5e76c845d"
    sha256 cellar: :any,                 big_sur:        "3b8efaafe447f0f3a218eb81a65d92715c35e3a703373256031cb0c3d9d21084"
    sha256 cellar: :any,                 catalina:       "12898a75c1d21de54fef1ca9c42c2d115d30ffcc9d7b10546c9c8d7428b467fa"
    sha256 cellar: :any,                 mojave:         "c45c383d9e0049ad94cbadb1f5bdd7b870bb01a9cdc8804f495e3ac48e8955d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35d1a87aeb3e38917032e7cd318742cbe3edc159deb39cfe70534c9ff149d7a1"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"

  on_linux do
    depends_on "libx11"
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "openal-soft"
    depends_on "systemd"
  end

  # https://github.com/Homebrew/homebrew/issues/40301

  def install
    # error: expected function body after function declarator
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https://github.com/Homebrew/homebrew/pull/35279) but leave the
    # headers that were moved there in https://github.com/SFML/SFML/pull/795
    rm_rf Dir["extlibs/*"] - ["extlibs/headers"]

    args = ["-DCMAKE_INSTALL_RPATH=#{opt_lib}",
            "-DSFML_MISC_INSTALL_PREFIX=#{share}/SFML",
            "-DSFML_INSTALL_PKGCONFIG_FILES=TRUE",
            "-DSFML_BUILD_DOC=TRUE"]

    args << "-DSFML_USE_SYSTEM_DEPS=ON" if OS.linux?

    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "Time.hpp"
      int main() {
        sf::Time t1 = sf::milliseconds(10);
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}/SFML/System", testpath/"test.cpp",
           "-L#{lib}", "-lsfml-system", "-o", "test"
    system "./test"
  end
end
