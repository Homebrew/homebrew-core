class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.7/stella-6.7-src.tar.xz"
  sha256 "babfcbb39abbd1a992cb1e6d3b2f508df7ed19cb9d0b5b5d624828bb98f97267"
  license "GPL-2.0-or-later"
  head "https://github.com/stella-emu/stella.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "721b36a943aab796fa12d945104c016ee7412a78ccc66a8f693481cdad1b5290"
    sha256 cellar: :any,                 arm64_monterey: "3e2b5920f695962de76de82cb7e26b5b5a6581d3f7452833ba6eb14f512cb616"
    sha256 cellar: :any,                 arm64_big_sur:  "cd289fabad0d7e63675f87b16648ae9c7ff2273705a7549a7563229f5306846e"
    sha256 cellar: :any,                 ventura:        "4410a18f444c6c5806d8f3c2ce237a1ba31a8eaf2a230761f3ce2256f395ed8f"
    sha256 cellar: :any,                 monterey:       "cd227d90fa8fdd64d31f0400f611bd5a5de5b5a95222b6f5cdf5ed478f987621"
    sha256 cellar: :any,                 big_sur:        "b1e5009fce0af66109809b65cd3d9d2fc313e588180a42f93a430618189e0f36"
    sha256 cellar: :any,                 catalina:       "142b80858ea794a2fc57b420b1a1a7ee4254bfbbab9eda09706978cd8a2cea6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f33ba21d74a54ccc7dcf1510060b5a88e104483c6257abbc2379a4bee0ebc6b6"
  end

  depends_on xcode: :build
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zlib"

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
        xcodebuild "-arch", Hardware::CPU.arch, "SYMROOT=build"
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
