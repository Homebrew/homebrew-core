class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/5.1/stella-5.1-src.tar.xz"
  sha256 "96a5ed7aa27f29e6af3643bf4af08e0441d46c1b3f47f0d0c55fa6f0e41f407b"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "d785be494c19b1254ae8d36173e03155cfe7ddb5904811a846b6d5b36e57f8cd" => :high_sierra
    sha256 "a5f27dadb73bac03b216c87bec7e4de593aadfdeaa6e1058d0a5c457d16a1071" => :sierra
    sha256 "443b004f1f0cf445b66a28a253a423f2f02ca32729a828ff2fb0ccc414a914f4" => :el_capitan
    sha256 "1f53b58fc29ced3dd2390191760481af1ecdf822653ff02b2e5a0ce5420f4ace" => :yosemite
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
