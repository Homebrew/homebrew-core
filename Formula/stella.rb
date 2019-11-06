class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.0.2/stella-6.0.2-src.tar.xz"
  sha256 "bcbd82294f97d00457fdb727e9b08ff73b685dc7f77704cea1eceb58d8967387"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "e8ba8548bb9a0eee1cc7ae25ece7a71ec34b659007fd28ed511785d2426f8bd9" => :catalina
    sha256 "9eb712f39ab97788ee8d7290e866a6bbf002ac31ba72f1e926a2c07831158a4a" => :mojave
    sha256 "8f9a6e8cfd9c54c78816526fe5050a1d299931ec150af1eead1fed485c1bd0f4" => :high_sierra
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
