class SfmlAT2 < Formula
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://www.sfml-dev.org/files/SFML-2.6.2-sources.zip"
  sha256 "19d6dbd9c901c74441d9888c13cb1399f614fe8993d59062a72cfbceb00fed04"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "81de83008ed518d05566483013d6bd9fcf2deb990a9c573e196e63d3010cc630"
    sha256 cellar: :any,                 arm64_sonoma:  "1a4898bf9ea25abe225a1eb962e24881917c2f849ac8132537eec72b12ad919d"
    sha256 cellar: :any,                 arm64_ventura: "5e5b2f83eec7708a256fab87bc043860b5fc9893acd6e72e016fac2b01f654f7"
    sha256 cellar: :any,                 sonoma:        "16a4f0fdc73c761f4559ea19eb8dc5d41436db882b2c38309484212f88e0e2b2"
    sha256 cellar: :any,                 ventura:       "6c889bce31b21d4b1c127923f98042b0a37588cc89ae4353ab0a4f9d7deaadea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14656fa808b17eed41a0dff41bb3d0dd0aacea4d03c8651ebbb8402e9109d507"
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
    # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
    # "error: expected function body after function declarator" on 10.12
    # Requires the CLT to be the active developer directory if Xcode is installed
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version <= :high_sierra

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
