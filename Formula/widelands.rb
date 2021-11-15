class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/v1.0.tar.gz"
  sha256 "1dab0c4062873cc72c5e0558f9e9620b0ef185f1a78923a77c4ce5b9ed76031a"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "2f992a280442581a1b0e5c7b766c9ef28e26f5423774d2939798c710173c5a23"
    sha256 arm64_big_sur:  "8f0377b940f20c79b0da12f8b5ae72d95424456b76c01d9b2f8f3032eae2b529"
    sha256 monterey:       "516c380cd46bf5756bd737942507a118badb316e782500d36c69d2deca8449c5"
    sha256 big_sur:        "443b39115903be7bd40d1f2353197a062a1210c42ff93f446ffc448a3ea5a183"
    sha256 catalina:       "fa60c7429eda358d559ae1b1d5b0db456135c24bfc8ad35f8668f77c3e09cf51"
    sha256 mojave:         "26663b82b323e4d087313ec8496f599d2aee39d5cb06c56da5576c257bca14b0"
    sha256 x86_64_linux:   "3602f01c5e080a62ee4644abf8163b164082de937a5259b258020a67a3766248"
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
    on_linux do
      # Unable to start Widelands, because we were unable to add the home directory:
      # RealFSImpl::make_directory: No such file or directory: /tmp/widelands-test/.local/share/widelands
      mkdir_p ".local/share/widelands"
      mkdir_p ".config/widelands"
    end

    system bin/"widelands", "--version"
  end
end
