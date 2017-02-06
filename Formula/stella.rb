class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "http://stella.sourceforge.net/"
  url "https://github.com/stella-emu/stella/releases/download/release-4.7.3/stella-4.7.3-src.tar.xz"
  sha256 "93a75d1b343b1e66b6dc526c0f9d8a0c3678d346033f7cdfe76dc93f14d956ad"
  head "http://svn.code.sf.net/p/stella/code/trunk"

  bottle do
    cellar :any
    sha256 "6fa4ea3d8025cde32168a81d3a6ec454180ffe23094492dd14e91a2b621075ca" => :sierra
    sha256 "39ced6c477334d1f584ebfadbc6a53d89b44e0608f4bbb6a82d4f4828833fb32" => :el_capitan
    sha256 "90c90e59652e47e450311d74c37c57ba4ab79491a1de09786c06be5376ea7bf5" => :yosemite
  end

  depends_on :xcode => :build
  depends_on "sdl2"
  depends_on "libpng"

  def install
    cd "src/macosx" do
      inreplace "stella.xcodeproj/project.pbxproj" do |s|
        s.gsub! %r{(\w{24} \/\* SDL2\.framework)}, '//\1'
        s.gsub! %r{(\w{24} \/\* png)}, '//\1'
        s.gsub! /(HEADER_SEARCH_PATHS) = \(/, "\\1 = (#{Formula["sdl2"].include}/SDL2, #{Formula["libpng"].include},"
        s.gsub! /(LIBRARY_SEARCH_PATHS) = \.;/, "\\1 = (#{Formula["sdl2"].lib}, #{Formula["libpng"].lib}, .);"
        s.gsub! /(OTHER_LDFLAGS) = "((-\w+)*)"/, '\1 = "-lSDL2 -lpng \2"'
      end
      xcodebuild "SYMROOT=build"
      prefix.install "build/Default/Stella.app"
      bin.write_exec_script "#{prefix}/Stella.app/Contents/MacOS/Stella"
    end
  end

  test do
    assert_match /Stella version #{version}/, shell_output("#{bin}/Stella -help").strip
  end
end
