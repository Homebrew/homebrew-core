class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/archive/refs/tags/6.7.1.tar.gz"
  sha256 "c65067ea0cd99c56a4b6a7e7fbb0e0912ec1f6963eccba383aece69114d5f50b"
  license "GPL-2.0-or-later"
  head "https://github.com/stella-emu/stella.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bf73b864a71f23c25b17f649fa7b90c2d946e5decd1413d105470ef98e9b4b34"
    sha256 cellar: :any,                 arm64_sonoma:   "cfac144680c89c52742d8a596eec4918feebdb7a3e875a6c526084c8bc08ae80"
    sha256 cellar: :any,                 arm64_ventura:  "6b5af4f6e25d26c7b4706601f88c4949137d4c3a821c8bc3401cd8c0ecf53ae8"
    sha256 cellar: :any,                 arm64_monterey: "8ec8e1b06fc15774fe03b7892ab6144e76b98762a0c697c359501678634d02de"
    sha256 cellar: :any,                 sonoma:         "d2019fbdb33bad5b55f175758ecce99d9ca866d489c04a35560327b7a230b9c3"
    sha256 cellar: :any,                 ventura:        "dc8d24e22aefe188c62ee96e42ba3a7f2816d5300af6926ad9ac678135ed607f"
    sha256 cellar: :any,                 monterey:       "6e29af042b7e50bf1e8992341bf53dc65caa6cf62247abb0330f5520ca0f4cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7689d9dae573a6288fe3be94adabad8791c2075d210faa27c82e624c4c6c6689"
  end

  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "sqlite"
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
        xcodebuild "-arch", Hardware::CPU.arch, "SYMROOT=build", "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
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
