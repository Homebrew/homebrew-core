class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://launchpad.net/widelands/build21/build21/+download/widelands-build21-source.tar.gz"
  version "21"
  sha256 "601e0e4c6f91b3fb0ece2cd1b83ecfb02344a1b9194fbb70ef3f70e06994e357"
  revision 3

  livecheck do
    url :stable
    regex(%r{<div class="version">\s*Latest version is [^<]*?v?(\d+(?:\.\d+)*)\s*</div>}i)
  end

  bottle do
    sha256 "397d51058f809f642fbf562675ca115abd5a1cb14082eb73adf1ecf6e9bd5213" => :catalina
    sha256 "ed0bde01ae136cd19e169c381ab7c368ec7c016f81b9be12ea8b12eb44a5a7d7" => :mojave
    sha256 "e1bff6047a59d1dd5ed4e308a326e98d798b2e1244230473e499e6a96f7abac3" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "doxygen"
  depends_on "gettext"
  depends_on "glew"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "lua"
  depends_on "minizip"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..",
                      # Without the following option, Cmake intend to use the library of MONO framework.
                      "-DPNG_PNG_INCLUDE_DIR:PATH=#{Formula["libpng"].opt_include}",
                      "-DWL_INSTALL_DATADIR=#{pkgshare}/data",
                       *std_cmake_args
      system "make", "install"

      (bin/"widelands").write <<~EOS
        #!/bin/sh
        exec #{prefix}/widelands "$@"
      EOS
    end
  end

  test do
    system bin/"widelands", "--version"
  end
end
