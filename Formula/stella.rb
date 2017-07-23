class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/5.0.1/stella-5.0.1-src.tar.xz"
  sha256 "34ff90b60a4d277ada2815c4d65eda18c87371d0fb15e872b8ac82aac3e0b07a"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "b621f5d5ec1b9da7fc14004bf9e778ffeafb558c0f2aa5f25591cda87d63d6f5" => :sierra
    sha256 "92267bef1ee7587675fe127b007f2d09e4b5dc746d31aa8b4fe71ae349469400" => :el_capitan
    sha256 "4fb86234d90175c69fcb3dd8fa074f09aaebc056421394dd3bb27eded39154a6" => :yosemite
  end

  depends_on :xcode => :build
  depends_on "sdl2"
  depends_on "libpng"

  def install
    sdl2 = Formula["sdl2"]
    libpng = Formula["libpng"]
    cd "src/macosx" do
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
