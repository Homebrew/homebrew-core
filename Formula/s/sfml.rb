class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://www.sfml-dev.org/files/SFML-2.6.0-sources.zip"
  sha256 "dc477fc7266641709046bd38628c909f5748bd2564b388cf6c750a9e20cdfef1"
  license "Zlib"
  head "https://github.com/SFML/SFML.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f81fcb668f0b343a8863489b33cbe7062a90f7ec28069b86e04339ed2a73a850"
    sha256 cellar: :any,                 arm64_monterey: "b6f6b53466d4b1ffba4b98d77daa194c323e88fb306225f8fe9960aaff7f4367"
    sha256 cellar: :any,                 arm64_big_sur:  "30abec4b2f8877b50f044d38fc1b8f10a159bfbf1b093792a86ccd79c6085e8f"
    sha256 cellar: :any,                 ventura:        "7a7194cecd4e0375834be5f36301789c583c893dbe4b145a8861f8620f1459db"
    sha256 cellar: :any,                 monterey:       "517fc7a77b3692b139f4323187693ace6c87bd83a1a21698916ac205b75bd655"
    sha256 cellar: :any,                 big_sur:        "528175b17d67dfd504df6804e03e88671f72b56e35bd68fe83cbcaf7cf404dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93c2c2be521fefca19dc534a177847cde4e70e2e8626847948a55fa911425574"
  end

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
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :high_sierra

    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https://github.com/Homebrew/homebrew/pull/35279) but leave the
    # headers that were moved there in https://github.com/SFML/SFML/pull/795
    rm_rf Dir["extlibs/*"] - ["extlibs/headers"]

    args = ["-DCMAKE_INSTALL_RPATH=#{lib}",
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
