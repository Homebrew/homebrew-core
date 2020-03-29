class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.1/stella-6.1-src.tar.xz"
  sha256 "73d90724d91b936bff58ccb245293baa74bc0b116f6efeab4570beb1c1898941"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "aa1ee2f18aa31a32d83a3b8400e2c9679e49fb14867bfe8d9ab1491af47aedcc" => :catalina
    sha256 "7310c1c995bf33adbbcde566a1eaf6aa9d2604b0dbfc09927878d197bad15c7f" => :mojave
    sha256 "9fe19cc03bf043ed3c19e8054741c39d4c6e8df78b0cf2c8b5615f76ac2104a5" => :high_sierra
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
