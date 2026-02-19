class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/archive/refs/tags/7.0c.tar.gz"
  version "7.0c"
  sha256 "b9309198aa5746cd568e91caaea10bbeab4ca8155493d0243694b41bdb39d7ca"
  license "GPL-2.0-or-later"
  head "https://github.com/stella-emu/stella.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "41e3a16e64aaf77fe123ddbd981aeeba3e994390c7d89c0c65f1c2925e7b7e9a"
    sha256 cellar: :any,                 arm64_sequoia: "91cbc6e702faf484f0f8155e09bc0c58b554d8ad83806f6fbccc175a5a2ee029"
    sha256 cellar: :any,                 arm64_sonoma:  "0b918bf3b40909f05f9efb55ffd1ea30edc2c5559f4bdbe005be7701e2d78364"
    sha256 cellar: :any,                 sonoma:        "bdf6adb03cc6b6c704ef07ba259ed76dd8079c8188ec6bffa533143da369f42e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecb978e4c694527a4ff05657d3eeee7afada54f357e13c145e1f49a61dec59cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "217c38a50c75643714b44317e94b3eef8118cd15ec1327277641a5cdaf76f78a"
  end

  depends_on "pkgconf" => :build
  depends_on xcode: :build # for xcodebuild
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # ventura build patch, upstream pr ref, https://github.com/stella-emu/stella/pull/1064
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/stella/7.0c-ventura.patch"
    sha256 "6295953eced4509376f4deb7b1ab511df5fed10cff4fab40feaa4ca8c53922ad"
  end

  def install
    sdl2 = Formula["sdl2"]
    libpng = Formula["libpng"]
    if OS.mac?
      cd "src/os/macos" do
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
                            "--with-zlib-prefix=#{Formula["zlib-ng-compat"].prefix}"
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
