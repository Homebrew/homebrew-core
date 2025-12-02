class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/SFML/archive/refs/tags/3.0.2.tar.gz"
  sha256 "0034e05f95509e5d3fb81b1625713e06da7b068f210288ce3fd67106f8f46995"
  license "Zlib"
  head "https://github.com/SFML/SFML.git", branch: "master"

  # Exclude release candidates
  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f90a54b2514303d50f3e7ce23554246b9a4bd6765db89158da55eef3b780ce98"
    sha256 cellar: :any,                 arm64_sequoia: "ca368852e45e73f7740343b736e20ddae613f326cbc24bc3779421c3c093c026"
    sha256 cellar: :any,                 arm64_sonoma:  "533db007d52c7b1ac24fe6699958baca1d989363f288d673b8c55b266efeedf4"
    sha256 cellar: :any,                 sonoma:        "01fb208923654ba730e48e3fbb5ca3bf78c09838f5a9e15bd389045732e65baa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cd68b13bddd404db5daa8a3a8a8ae8fd9236f59896374fb50514dea41628ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4c2c78c094ed8eb9b9ec3a5c2d45b0cf0975edcf165ed97d58762b371fb7fe9"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libvorbis"

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxi"
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "openal-soft"
    depends_on "systemd"
  end

  def install
    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https://github.com/Homebrew/homebrew/pull/35279) but leave the
    # headers that were moved there in https://github.com/SFML/SFML/pull/795
    rm_r(Dir["extlibs/*"] - ["extlibs/headers"])

    args = [
      "-DBUILD_SHARED_LIBS=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DSFML_INSTALL_PKGCONFIG_FILES=TRUE",
      "-DSFML_PKGCONFIG_INSTALL_DIR=#{lib}/pkgconfig",
      "-DSFML_BUILD_DOC=TRUE",
      "-DSFML_USE_SYSTEM_DEPS=ON",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target=doc"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "Time.hpp"
      int main() {
        sf::Time t1 = sf::milliseconds(10);
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{include}/SFML/System", "-std=c++17", testpath/"test.cpp",
                    "-L#{lib}", "-lsfml-system", "-o", "test"
    system "./test"
  end
end
