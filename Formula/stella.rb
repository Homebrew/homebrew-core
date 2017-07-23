class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/5.0.1/stella-5.0.1-src.tar.xz"
  sha256 "34ff90b60a4d277ada2815c4d65eda18c87371d0fb15e872b8ac82aac3e0b07a"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "62cc1956e830b9dd2d6e3c5af5a73c548a14c671f40af2f73374604b4fb265dd" => :sierra
    sha256 "06ade7c7621586cfc5d46089d599af04cd3d05678b9ef1c103c19f9f4f12a1ac" => :el_capitan
    sha256 "d4a5e838b4fb6766fdc86af516c0aeb3ae3db869bf101ef0e4f4caced939fd7e" => :yosemite
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
