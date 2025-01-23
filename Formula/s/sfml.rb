class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://www.sfml-dev.org/files/SFML-3.0.0-sources.zip"
  sha256 "8cc41db46b59f07c44ecf21c74a0f956d37735dec9d90ff4522856cb162ba642"
  license "Zlib"
  head "https://github.com/SFML/SFML.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "fff37927fb4f670430d85f49261b6154978e0216d55768b7d5a1a5168232d18f"
    sha256 cellar: :any,                 arm64_sonoma:  "ff020fbbaccb4b711f2fb9eff376c43f6ccd900e3f1e48d20636524aaa67c9b9"
    sha256 cellar: :any,                 arm64_ventura: "3dfa4ab8f4d7242edb31a6f9e862c1f4322f45fec06fefc992e7c9d1764d6c80"
    sha256 cellar: :any,                 sonoma:        "b941f80dc54ebbf31d9853ceef9a5c72641e10810f2dbbbf40375d32da1a95cb"
    sha256 cellar: :any,                 ventura:       "31f1099add9105e6d52e114b60587fb84a4c11c5a2f9e4312d7c5a6336fde916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2caae5a406d4744b0bf2e718a56b20d0a51e3f936d7343802a6bcd2a552dfc72"
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
    # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
    # "error: expected function body after function declarator" on 10.12
    # Requires the CLT to be the active developer directory if Xcode is installed
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version <= :high_sierra

    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https://github.com/Homebrew/homebrew/pull/35279) but leave the
    # headers that were moved there in https://github.com/SFML/SFML/pull/795
    rm_r(Dir["extlibs/*"] - ["extlibs/headers"])

    args = [
      "-DBUILD_SHARED_LIBS=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DSFML_INSTALL_PKGCONFIG_FILES=TRUE",
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
