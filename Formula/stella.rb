class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.5.3/stella-6.5.3-src.tar.xz"
  sha256 "b49d5e5a5aa872e1f4b6f24eabd72304abdd577801d6ec349760c73b99e7f14d"
  license "GPL-2.0-or-later"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    sha256 cellar: :any, big_sur:  "413ec06db90b9e5fd3f704e8181e50d4d39c88ff579c0e9dc523ee74b2ad3558"
    sha256 cellar: :any, catalina: "7765c2e205dc182aab86de151356ae6a586585a076cea5f9d0d82708447a0427"
    sha256 cellar: :any, mojave:   "228ac66abf639dce733dce76c6cde14c122c84c12476c1663a64243ac609994a"
  end

  depends_on xcode: :build
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zlib"

  def install
    sdl2 = Formula["sdl2"]
    libpng = Formula["libpng"]
    cd "src/macos" do
      inreplace "stella.xcodeproj/project.pbxproj" do |s|
        s.gsub! %r{(\w{24} /\* SDL2\.framework)}, '//\1'
        s.gsub! %r{(\w{24} /\* png)}, '//\1'
        s.gsub!(/(HEADER_SEARCH_PATHS) = \(/,
                "\\1 = (#{sdl2.opt_include}/SDL2, #{libpng.opt_include},")
        s.gsub!(/(LIBRARY_SEARCH_PATHS) = ("\$\(LIBRARY_SEARCH_PATHS\)");/,
                "\\1 = (#{sdl2.opt_lib}, #{libpng.opt_lib}, \\2);")
        s.gsub!(/(OTHER_LDFLAGS) = "((-\w+)*)"/, '\1 = "-lSDL2 -lpng \2"')
      end
      xcodebuild "SYMROOT=build"
      prefix.install "build/Release/Stella.app"
      bin.write_exec_script "#{prefix}/Stella.app/Contents/MacOS/Stella"
    end
  end

  test do
    assert_match "Stella version #{version}", shell_output("#{bin}/Stella -help").strip
  end
end
