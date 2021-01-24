class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.5.1/stella-6.5.1-src.tar.xz"
  sha256 "0348a76e76a5a3feb41aa776a27501fa3c5f51a2159ec06525f4ee8d0e71d414"
  license "GPL-2.0-or-later"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "a25a476ae41b6dd2c5c29802fba4ca3bf35074c639cf4cbbf768f3f36715bc71" => :big_sur
    sha256 "238e5f14053929242ec5b359c71e65e23d6787cfe2c39b3c0d115b97be710921" => :catalina
    sha256 "3afbebc86b00893a2668de1dba200e616a0e1446e66672589f18ce8c944e500b" => :mojave
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
        s.gsub! /(HEADER_SEARCH_PATHS) = \(/,
                "\\1 = (#{sdl2.opt_include}/SDL2, #{libpng.opt_include},"
        s.gsub! /(LIBRARY_SEARCH_PATHS) = ("\$\(LIBRARY_SEARCH_PATHS\)");/,
                "\\1 = (#{sdl2.opt_lib}, #{libpng.opt_lib}, \\2);"
        s.gsub! /(OTHER_LDFLAGS) = "((-\w+)*)"/, '\1 = "-lSDL2 -lpng \2"'
      end
      xcodebuild "SYMROOT=build"
      prefix.install "build/Release/Stella.app"
      bin.write_exec_script "#{prefix}/Stella.app/Contents/MacOS/Stella"
    end
  end

  test do
    assert_match /Stella version #{version}/, shell_output("#{bin}/Stella -help").strip
  end
end
