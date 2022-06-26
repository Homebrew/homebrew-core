class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.7/stella-6.7-src.tar.xz"
  sha256 "babfcbb39abbd1a992cb1e6d3b2f508df7ed19cb9d0b5b5d624828bb98f97267"
  license "GPL-2.0-or-later"
  head "https://github.com/stella-emu/stella.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "77773fb03e92c01def740b7acba99c765ed509e04b0adf0372d59f11634fdc92"
    sha256 cellar: :any,                 arm64_big_sur:  "f1d2831b612ce334a42b340e15482f4abfea1095f2850904b87fb388f5b644e6"
    sha256 cellar: :any,                 monterey:       "93530cff4003a6155360f6a7683913d536a81856909672d1db4a750a9ccf87d9"
    sha256 cellar: :any,                 big_sur:        "6a982f58468560bdb62cec0d2235e56343b7373a93176a0af005c0f7ee5329e8"
    sha256 cellar: :any,                 catalina:       "9f01df79243f051af7f6634646b7398ba8d380fa9213233b0f01f6c4a13e9fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aae8f6b0df12475faeafb6bcfb80c6009bdd68539e301a7bb945571be9e363e"
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
