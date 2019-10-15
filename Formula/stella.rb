class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.0.1/stella-6.0.1-src.tar.xz"
  sha256 "d611f98bb35ed9eacfb63826b12b4e8b67b874a2a87019d4bdaf1e7f4724c40d"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "9a4e6b5242ce39f7a264c3298b0cd927197aba25ecf3ffd20c0f1e2310c75779" => :catalina
    sha256 "9356bf82472ace4d0c9fe325fba4239ff990cb7ae89ca47090512d79a07619b1" => :mojave
    sha256 "c8218d2bdb301dd5f4268c4b7fc16e88676740d69106b76729955ccd18a795da" => :high_sierra
    sha256 "68d9cc4bb6dd3ff15efb113824546c03c55c856927ba4fff9b36ec18246b820f" => :sierra
  end

  depends_on :xcode => :build
  depends_on "libpng"
  depends_on "sdl2"

  def install
    sdl2 = Formula["sdl2"]
    libpng = Formula["libpng"]
    cd "src/macos" do
      inreplace "stella.xcodeproj/project.pbxproj" do |s|
        s.gsub! %r{(\w{24} \/\* SDL2\.framework)}, '//\1'
        s.gsub! %r{(\w{24} \/\* png)}, '//\1'
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
