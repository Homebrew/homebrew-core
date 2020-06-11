class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.2/stella-6.2-src.tar.xz"
  sha256 "d45a7354513fa0d56a6290d1f3182f4c4e6621ab44228d829d923de535921410"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "95489748fc443e42532c1ff421638ed72c6ab17313fb0ab2ebcf9273182829ef" => :catalina
    sha256 "9816e57d6fda42554766bb020bb86e7149b82c8d3d5723a4e263f2298798318c" => :mojave
    sha256 "448f952086ef9e6501c0153c838216e9198833bbca4c0d6d5b0b79adf2e09fcd" => :high_sierra
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
