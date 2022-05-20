class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/v1.0.tar.gz"
  sha256 "1dab0c4062873cc72c5e0558f9e9620b0ef185f1a78923a77c4ce5b9ed76031a"
  revision 1
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "bb327c0a61a6f7d34a49adc7348cfc0612f99388df3a360e642003b6f271cdc2"
    sha256 arm64_big_sur:  "b271f78a4f64c24649aa7f434875d833db9dc450693851b762d475bd55710ccb"
    sha256 monterey:       "6841c81de61bf890330d1525f265803e331cb053005fc283a774ad014860da06"
    sha256 big_sur:        "c871a2c1f34ccb2a392de9096f271736290d7b95f7608c76db072f5a1dd4419e"
    sha256 catalina:       "696f0dca61b246ecb2e5b50eb3f2be2e89703c0f359136beeae9825fcf1f24e8"
    sha256 x86_64_linux:   "006b742ffc51ffb20b479c042c1bf62daa7b30cb5aa2ad16386a0f0246b8c1ed"
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

  uses_from_macos "curl"

  # Fix build with Boost 1.77+.
  # Remove with the next release (1.1).
  patch do
    url "https://github.com/widelands/widelands/commit/316eaea209754368a57f445ea4dd016ecf8eded6.patch?full_index=1"
    sha256 "358cae53bbc854e7e9248bdea0ca5af8bce51e188626a7f366bc6a87abd33dc9"
  end

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
    if OS.linux?
      # Unable to start Widelands, because we were unable to add the home directory:
      # RealFSImpl::make_directory: No such file or directory: /tmp/widelands-test/.local/share/widelands
      mkdir_p ".local/share/widelands"
      mkdir_p ".config/widelands"
    end

    system bin/"widelands", "--version"
  end
end
