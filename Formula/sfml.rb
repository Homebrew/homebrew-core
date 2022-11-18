class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://www.sfml-dev.org/files/SFML-2.5.1-sources.zip"
  sha256 "bf1e0643acb92369b24572b703473af60bac82caf5af61e77c063b779471bb7f"
  license "Zlib"
  revision 2
  head "https://github.com/SFML/SFML.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ca56d2babc673b63418e28ff62d1836e6a6759315327f9ebba79740261f929d4"
    sha256 cellar: :any,                 arm64_monterey: "31276f049496d80aed1bd4872b5764f26a74693445beb5d1142af08be061dad3"
    sha256 cellar: :any,                 arm64_big_sur:  "66629eea47ae1f4be17c0c8a662b5a748d508bfd1fa45baac102b6d43977295a"
    sha256 cellar: :any,                 ventura:        "233a8fb75fbdc79eb9b03c519aa7e9b3e209a74476d113152c6f60d5311b05dd"
    sha256 cellar: :any,                 monterey:       "2dea0d7dd5f7580840e0610bcdda13bb330009cb72d0d95dc57e5e2bdcbd7cad"
    sha256 cellar: :any,                 big_sur:        "53876147c9bd9b7dd1f4f165eb398ada5afd80c416ab937868903a5798dadaed"
    sha256 cellar: :any,                 catalina:       "6cd5cb0527db2de9870ce49e57d74195b1c42be618a28416c8ccfd5c6e82419f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76eb5b0e6826209822a4e8fff4606f6c964e8aa8aaffd4edaef4d7a3811f7ed7"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "flac"
  depends_on "freetype"
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

  def install
    # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
    # "error: expected function body after function declarator" on 10.12
    # Requires the CLT to be the active developer directory if Xcode is installed
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :high_sierra

    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https://github.com/Homebrew/homebrew/pull/35279) but leave the
    # headers that were moved there in https://github.com/SFML/SFML/pull/795
    rm_rf Dir["extlibs/*"] - ["extlibs/headers"]

    args = ["-DCMAKE_INSTALL_RPATH=#{opt_lib}",
            "-DSFML_MISC_INSTALL_PREFIX=#{share}/SFML",
            "-DSFML_INSTALL_PKGCONFIG_FILES=TRUE",
            "-DSFML_BUILD_DOC=TRUE"]

    args << "-DSFML_USE_SYSTEM_DEPS=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
