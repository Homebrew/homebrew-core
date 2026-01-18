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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5dd257952715ad8364652c9cdb0ef7e8cfab72f2f868273e7da13928ce8dc065"
    sha256 cellar: :any,                 arm64_sequoia: "470bf4006df3634a8ee8d49e9424569f0a9bafb600a2e6c72c4a66f424013c5b"
    sha256 cellar: :any,                 arm64_sonoma:  "0bb05c3c49f855456ae66086076ba5c51eaa4c146fbd34b688d98475dc8410dc"
    sha256 cellar: :any,                 sonoma:        "4e137c751a90176b2ae74f8bf4b5d41d4bdc2250b5dd225ce3746483abb8a202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "307f9ee104dcde3fe968406b3991cb49a0ea10f732c46ae9509a9dd96246ced8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b316ebff91f8c1c19294ba17cda529c4a929b16f5c38a9c2ffd815f5ae91e032"
  end

  depends_on "pkgconf" => :build
  depends_on xcode: :build # for xcodebuild
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

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
