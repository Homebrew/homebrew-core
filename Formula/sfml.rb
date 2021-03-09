class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://www.sfml-dev.org/files/SFML-2.5.1-sources.zip"
  sha256 "bf1e0643acb92369b24572b703473af60bac82caf5af61e77c063b779471bb7f"
  license "Zlib"
  revision 1
  head "https://github.com/SFML/SFML.git"

  bottle do
    sha256 arm64_big_sur: "4ea8183ad7187a6c2f29522d61ff2446f034484fe4341c81c12c2b4fa727e661"
    sha256 big_sur:       "3acd05aacb9f9f8e87d99ecbaab09d976a7f151d822d6950e4d13697f0297443"
    sha256 catalina:      "cdc8de4d6d5b63dd4334a33cc6c6f2f57e3686a5305d22b89579748237ac4d67"
    sha256 mojave:        "311051956872de3bb215c1f4c0bc618157fbfb495f92acc7552b8efb76cf4fe3"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"

  # https://github.com/Homebrew/homebrew/issues/40301

  def install
    # error: expected function body after function declarator
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https://github.com/Homebrew/homebrew/pull/35279) but leave the
    # headers that were moved there in https://github.com/SFML/SFML/pull/795
    rm_rf Dir["extlibs/*"] - ["extlibs/headers"]

    system "cmake", ".", *std_cmake_args,
                         "-DCMAKE_INSTALL_RPATH=#{opt_lib}",
                         "-DSFML_MISC_INSTALL_PREFIX=#{share}/SFML",
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
