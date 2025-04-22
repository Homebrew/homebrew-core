class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/archive/refs/tags/7.0c.tar.gz"
  version "7.0c"
  sha256 "1b40955f24f3f1f00dff0f4cb46bc1cab4c5e1b9017521b525c5e304be554e3a"
  license "GPL-2.0-or-later"
  head "https://github.com/stella-emu/stella.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "01b8c2228d4e79fe4353b9a84ce3a25fb60dfe8a7616feec7909d0f6f9fa0aa2"
    sha256 cellar: :any,                 arm64_sonoma:  "1c4bd3b235c0bc7eed68982e3d7aadf17d7d0b576850043d14622ccda12f9a01"
    sha256 cellar: :any,                 arm64_ventura: "9006d2d1c2a917ffb68711f4dea71afb2eafe4c3d0ebc4ad719d2523cdfabc4b"
    sha256 cellar: :any,                 sonoma:        "a6538fcd6efcdd248764b6608f05f02a5589c820196d752af28501a873177959"
    sha256 cellar: :any,                 ventura:       "fe04bbcb3564ebd30f3a507a1c488f4ef8ffb57c8da468f32ac73175e59dc5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c87bac821cbd8b547480bd72554baa71fd960b5e60d662760f34c3c1e31a2bb9"
  end

  depends_on "pkgconf" => :build
  depends_on xcode: :build # for xcodebuild
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  # ventura build patch, upstream pr ref, https://github.com/stella-emu/stella/pull/1064
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/932732469b2d4ace873187b55973cce3e1627b34/stella/7.0c-ventura.patch"
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
