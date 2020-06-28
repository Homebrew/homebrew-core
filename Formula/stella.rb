class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.2.1/stella-6.2.1-src.tar.xz"
  sha256 "47b991af880b1699614c081d602c197942cfbdcbf52e3d738617923d5df23dc7"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "e074eb84ee736d9d79e2e335f3dd467c8a367e57e82047b273485f6cb396139f" => :catalina
    sha256 "df25eb2cd8f94d6574a0b2a3e0e776ba193afbbefd9882801b32712247cac681" => :mojave
    sha256 "8bd7aff3b2b8299058daa97a63d8a068389998ad7d0bd51a6715c85556679a2c" => :high_sierra
  end

  depends_on :xcode => :build
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
