class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://www.sfml-dev.org/files/SFML-2.6.1-sources.zip"
  sha256 "5bf19e5c303516987f7f54d4ff1b208a0f9352ffa1cd55f992527016de0e8cb7"
  license "Zlib"
  head "https://github.com/SFML/SFML.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a7975776a6cc79b56b3f24e2b479ebec22de528a0d0ceb39a2661b817e249dd5"
    sha256 cellar: :any,                 arm64_ventura:  "dfb67204535360d3addd78d234dfebc885766bca2ca0e16a92225aec0228dcd1"
    sha256 cellar: :any,                 arm64_monterey: "318fa96aca743fb92d730fd8ddfdd583173f9022e989c0931435035cc25cd3db"
    sha256 cellar: :any,                 sonoma:         "c879bf7e4b5f343a9c821a35f232c0238021b9e97ba6308f86b307cd59836714"
    sha256 cellar: :any,                 ventura:        "8a65d2d67f7fa763bac2b15c85b3ec7c0c6db3aab2cc2b2a3a9a2891061e532b"
    sha256 cellar: :any,                 monterey:       "b81ac4939baef78b092833edf511cb3ee32c303799aed32454f09c206706bb29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d0504ed719b8fefc75d3a8c92a4658e86e648c2f318d7ed994224518ee8f479"
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
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && version <= :high_sierra

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
