class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://www.sfml-dev.org/files/SFML-2.4.2-sources.zip"
  sha256 "8ba04f6fde6a7b42527d69742c49da2ac529354f71f553409f9f821d618de4b6"
  head "https://github.com/SFML/SFML.git"

  bottle do
    cellar :any
    sha256 "054c35f4e582cc360aa216e453b983db523a76c42ea007755d60f76b47a84048" => :sierra
    sha256 "e0bf245151452a3f7bc09205fd831c7fcfd936fff4ac366dc7a15f1f09b32b21" => :el_capitan
    sha256 "e1febe460b334ce2dca457a030a350380679ce1e4ca7e4025bba5cb775c829a8" => :yosemite
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
