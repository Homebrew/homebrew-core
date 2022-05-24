class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.6/stella-6.6-src.tar.xz"
  sha256 "d481efc6d27b5294565dfcc10983de2dbc4db8a59932a678ffdb4d2404b8c207"
  license "GPL-2.0-or-later"
  head "https://github.com/stella-emu/stella.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 monterey:     "72e0d2b7a302b102a942fbc30d3b877792e676f2ea28608d874e64bf9cf88020"
    sha256 cellar: :any,                 big_sur:      "0b8b9b3ea9c9e27a5274adc3a849c19fd41385fbc39a09d3b3af368399f97a06"
    sha256 cellar: :any,                 catalina:     "bc346d37156a2a5adae7d11e52dfd3d4d0bfad70f68826cba5cd94ced66e59da"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f5e2f0fe6837b8420b5ba6be490ee02eb965c6c3a129e8df8a6836797601befb"
  end

  depends_on xcode: :build
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    sdl2 = Formula["sdl2"]
    libpng = Formula["libpng"]
    if OS.mac?
      cd "src/macos" do
        inreplace "stella.xcodeproj/project.pbxproj" do |s|
          s.gsub! %r{(\w{24} /\* SDL2\.framework)}, '//\1'
          s.gsub! %r{(\w{24} /\* png)}, '//\1'
          s.gsub!(/(HEADER_SEARCH_PATHS) = \(/,
                  "\\1 = (#{sdl2.opt_include}/SDL2, #{libpng.opt_include},")
          s.gsub!(/(LIBRARY_SEARCH_PATHS) = ("\$\(LIBRARY_SEARCH_PATHS\)");/,
                  "\\1 = (#{sdl2.opt_lib}, #{libpng.opt_lib}, \\2);")
          s.gsub!(/(OTHER_LDFLAGS) = "((-\w+)*)"/, '\1 = "-lSDL2 -lpng \2"')
        end
        xcodebuild "SYMROOT=build"
        prefix.install "build/Release/Stella.app"
        bin.write_exec_script "#{prefix}/Stella.app/Contents/MacOS/Stella"
      end
    else
      system "./configure", "--prefix=#{prefix}",
                            "--bindir=#{bin}",
                            "--enable-release",
                            "--with-sdl-prefix=#{sdl2.prefix}",
                            "--with-libpng-prefix=#{libpng.prefix}",
                            "--with-zlib-prefix=#{Formula["zlib"].prefix}"
      system "make", "install"
    end
  end

  test do
    if OS.mac?
      assert_match "E.T. - The Extra-Terrestrial", shell_output("#{bin}/Stella -listrominfo").strip
    else
      assert_match "failed to initialize: unable to open database file",
        shell_output("#{bin}/stella -listrominfo").strip
    end
  end
end
