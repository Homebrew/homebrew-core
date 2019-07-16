class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.0.1/stella-6.0.1-src.tar.xz"
  sha256 "d611f98bb35ed9eacfb63826b12b4e8b67b874a2a87019d4bdaf1e7f4724c40d"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "6880937715c2f6961602ee8b3ec4061ade86e40cdabdbe917c7f16b0b979ab35" => :mojave
    sha256 "382b6e15d5a8dca9745bb1ba933da077cbd2d11b74b971f031933b8745450e1c" => :high_sierra
    sha256 "f5b874f65035eb9825ac68d3cebef565945cb62eb7f3d6708f8dc051f55f8579" => :sierra
    sha256 "3f71f5dfa4f921dcc8ff076e7054f13599ea2484c1927a7f0c67a33080713fb5" => :el_capitan
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
