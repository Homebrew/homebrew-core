class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "http://www.sfml-dev.org/"
  url "http://www.sfml-dev.org/files/SFML-2.4.0-sources.zip"
  sha256 "868a1a1e43a7ee40c1a90efcbcea061b6f0a6ed129075d9a8f19c8c69e644b0f"
  head "https://github.com/SFML/SFML.git"

  bottle do
    cellar :any
    sha256 "e1bc85c3f1c4f7342f36fcdcc710b20e8e04f33148cb04881cc9212bfca53416" => :el_capitan
    sha256 "24f77359cd2e01ca9311594217722b83228e8fa0f45dfb86d385ccf00fd16947" => :yosemite
    sha256 "c548482a327731074d32195e214297ec99e8940632f62bb46b16cce6dd4e0ec4" => :mavericks
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
