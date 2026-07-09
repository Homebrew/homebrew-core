class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  license "GPL-2.0-or-later"
  revision 1

  stable do
    url "https://github.com/stella-emu/stella/archive/refs/tags/7.0c.tar.gz"
    version "7.0c"
    sha256 "b9309198aa5746cd568e91caaea10bbeab4ca8155493d0243694b41bdb39d7ca"
    depends_on "sdl2-compat"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "703f3018a3b24a427048fbdccfc071351ad394c18de036ecad0d3ad1e315755a"
    sha256 cellar: :any, arm64_sequoia: "8827c4413e4115e2112db911ea5e1452c6fda6ae7107c1a8978b52a217aff422"
    sha256 cellar: :any, arm64_sonoma:  "4196ed342ac1beb49afa9a24aebe632edae3428b7609db964304c599730de83e"
    sha256 cellar: :any, sonoma:        "e8bc2f7983e6ea2f42cafb9a8e2096a4ea9d3299b5680473fbbc4a44f724157d"
    sha256 cellar: :any, arm64_linux:   "d01cea3aa44e1b08101353e9aaff609b1912648969665b4ab861bb2dbe0bc1c6"
    sha256 cellar: :any, x86_64_linux:  "b2370389aec764f2df7f6bdbafb6e66008dbb3044fa4a982fd3b61b0d2335242"
  end

  head do
    url "https://github.com/stella-emu/stella.git", branch: "master"
    depends_on "sdl3"
  end

  depends_on "pkgconf" => :build
  depends_on "libpng"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Remove bundled libraries
    inreplace "configure", /^\s*_libsqlite3=no$/, "" if OS.mac?
    rm_r(["src/lib/libpng", "src/lib/sqlite", "src/lib/zlib"])

    system "./configure", "--enable-release", *std_configure_args
    system "make", "install"
  end

  test do
    # "ERROR: Couldn't initialize SDL: No available video device"
    ENV["SDL_VIDEODRIVER"] = "dummy" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "E.T. - The Extra-Terrestrial", shell_output("#{bin}/stella -listrominfo").strip
  end
end
