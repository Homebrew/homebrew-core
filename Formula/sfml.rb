class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://www.sfml-dev.org/files/SFML-2.4.2-sources.zip"
  sha256 "8ba04f6fde6a7b42527d69742c49da2ac529354f71f553409f9f821d618de4b6"
  revision 1
  head "https://github.com/SFML/SFML.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1c5fc7fdb1a59664f2128d309c3a198fffd60cb9f930fbe8ed7f8eb52753250b" => :mojave
    sha256 "ed02627dfaff55b60f9271379256d99adfb010df3f4842b0e33fd366eb62df6e" => :high_sierra
    sha256 "76c3949dad4b907b87d219f10eb2dae44d43cb76963a083f70935f138832d13c" => :sierra
    sha256 "976560145b126bd482696148767f333ceda470d847064a5682abcd5c329937bd" => :el_capitan
    sha256 "43dbf56a522f7bce55db7e5354ee0810b7abad63b97178a1ed7a73356c52577c" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"

  # https://github.com/Homebrew/homebrew/issues/40301
  depends_on :macos => :lion

  def install
    # Install pkg-config files, adding the CMake flag below isn't enough, as
    # the CMakeLists.txt file currently doesn't consider MacOS X.
    # This was fixed upstream for the future 2.5.0 release on 2016-12-19 in:
    # https://github.com/SFML/SFML/commit/5fe5e5d6d7792e37685a437551ffa8ed5161fcc1
    inreplace "CMakeLists.txt",
              "if(SFML_OS_LINUX OR SFML_OS_FREEBSD)",
              "if(SFML_OS_LINUX OR SFML_OS_FREEBSD OR SFML_OS_MACOSX)"

    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https://github.com/Homebrew/homebrew/pull/35279) but leave the
    # headers that were moved there in https://github.com/SFML/SFML/pull/795
    rm_rf Dir["extlibs/*"] - ["extlibs/headers"]

    system "cmake", ".", *std_cmake_args,
                         "-DSFML_INSTALL_PKGCONFIG_FILES=TRUE",
                         "-DSFML_BUILD_DOC=TRUE"
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
    system ENV.cxx, "-I#{include}/SFML/System", "-L#{lib}", "-lsfml-system",
           testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
