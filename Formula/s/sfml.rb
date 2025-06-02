class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/SFML/archive/refs/tags/3.0.1.tar.gz"
  sha256 "f99f71bb2f2608835b1a37e078512b75dd39d52b89e13e12246603a950da3c1f"
  license "Zlib"
  head "https://github.com/SFML/SFML.git", branch: "master"

  # Exclude release candidates
  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "219438b2d39684b110414e0c199ef9c303bb14ea442d5de6aed2805564c2525e"
    sha256 cellar: :any,                 arm64_sonoma:  "41e3ddc554afb5b505cb036672539652b5981591fb62d02797c16fac39217f69"
    sha256 cellar: :any,                 arm64_ventura: "6f124cf63ea4944b4f395a06848b6b6d8e47f2e029dc029814271d4e8a38215a"
    sha256 cellar: :any,                 sonoma:        "f56186107e571de0d38538cb941ae6598636513c575672e24ef4641e9038ac1f"
    sha256 cellar: :any,                 ventura:       "3351ec1251bbc1c8b5dbac9c20807e70e32df6581e69b3ea1f821224eb3933e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af868781ca4dabd34f9ee0a16a25dd414184fd2e4373c9f01bd6bbc65b7bcc34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fee6dff9705e907632542b1279f71c880f676cf235a5a3aba457a235c23fd709"
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
