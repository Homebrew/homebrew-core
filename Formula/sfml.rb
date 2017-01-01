class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "http://www.sfml-dev.org/"
  url "http://www.sfml-dev.org/files/SFML-2.4.1-sources.zip"
  sha256 "f75096b2dc9cae67e10a28dbbefc9fe02e9dbe2e1ed50f2e208046bae9d3c9a4"
  head "https://github.com/SFML/SFML.git"

  bottle do
    cellar :any
    sha256 "9fb1866d1198e3b2d18eb20c1f43b848d052cf214ee5c37e62096ecac42d7a6b" => :sierra
    sha256 "1c0f246ec03d8551919eec4a68b1608c089861615eb2fbf8891cd0e7dcb2952c" => :el_capitan
    sha256 "34bdc7fc997835f9a182c22695a9d9e0fb49ea7cd471aa51a8d7c418f31d81c9" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :optional
  depends_on "flac"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "openal-soft" => :optional

  # https://github.com/Homebrew/homebrew/issues/40301
  depends_on :macos => :lion

  def install
    args = std_cmake_args
    args << "-DSFML_BUILD_DOC=TRUE" if build.with? "doxygen"

    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https://github.com/Homebrew/homebrew/pull/35279) but leave the
    # headers that were moved there in https://github.com/SFML/SFML/pull/795
    rm_rf Dir["extlibs/*"] - ["extlibs/headers"]

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
