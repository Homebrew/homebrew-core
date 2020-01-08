class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://www.sfml-dev.org/files/SFML-2.5.1-sources.zip"
  sha256 "bf1e0643acb92369b24572b703473af60bac82caf5af61e77c063b779471bb7f"
  head "https://github.com/SFML/SFML.git"

  bottle do
    cellar :any
    sha256 "b94077b2fc05c84af837de5bdf0681c1538c07b320b40155dd7f81cff809d37c" => :catalina
    sha256 "3f4dd43eb91902d4c4f7558d965b372ace9b1227185c55db5172a7f599593caa" => :mojave
    sha256 "72544adffb4dea8194163d44f16588c2c85ab795ba02eb7b93a9d687f2958383" => :high_sierra
    sha256 "ab58d3643f256258efe63d74689bfb4eae7dd012665552e61eb6bb749af08f77" => :sierra
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
