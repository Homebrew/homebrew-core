class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "http://www.sfml-dev.org/"
  url "http://www.sfml-dev.org/files/SFML-2.3.2-sources.zip"
  sha256 "03fe79943c48222037f1126a581b12c95a4dd53168881907964695c5ec3dc395"
  head "https://github.com/SFML/SFML.git"

  bottle do
    cellar :any
    revision 1
    sha256 "ad7dd2e41bfa6f64a26126b984195e1c82ddfc8f0b0565e48e01bc2e0f78bc34" => :el_capitan
    sha256 "dce3b6fd761739d01aecbce2a06f5cea8739d8a1336e8ce61079aecd56004851" => :yosemite
    sha256 "1ae3b7fbe5965b1d5e4e8ed08e3184aaac57cc547dbb78e9d5e7b64dc8589a00" => :mavericks
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
