class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://www.mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0280.tar.gz"
  version "0.280"
  sha256 "ffebdf23f2e3b3628e86e1bf9a217343c7c0462b94e3a201f20e3ebc848bd578"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f2344a59ffde0d3e5746e18e5c5e6a5151cd392b6229de969d280db7ba7765fb"
    sha256 cellar: :any,                 arm64_sequoia: "b61953aeb127c7350ca3b9e028e1fd71b42b9933ac6f5ab9af4e621ecd0144bf"
    sha256 cellar: :any,                 arm64_sonoma:  "e6eb9ce165030d61dff20c9cd62c7b475a43510d66eac59071276e5a54321d1e"
    sha256 cellar: :any,                 arm64_ventura: "819eef671c0e0b32f39fad723e801da340b22a443e6e9b94c50cee9fc05c0ed1"
    sha256 cellar: :any,                 sonoma:        "94c4385cc4de09ff3c262e932c15286fcaa1e2df7156b7b52de790fa18f759ee"
    sha256 cellar: :any,                 ventura:       "7c436d686145b5c63c06d545fe0f66640aea685affb218f772b62c24adef1483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d42747ecd920970471487fcba07f84bdc4d543bc3bbf3e76d53f71876046134"
  end

  depends_on "asio" => :build
  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "sdl2"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "portaudio" => :build
    depends_on "portmidi" => :build
    depends_on "pulseaudio" => :build
    depends_on "qt" => :build
    depends_on "sdl2_ttf" => :build
  end

  def install
    ENV["QT_HOME"] = Formula["qt"].opt_prefix if OS.linux?

    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    args = %W[
      PYTHON_EXECUTABLE=#{which("python3")}
      TOOLS=1
      EMULATOR=0
      USE_LIBSDL=1
      USE_SYSTEM_LIB_EXPAT=1
      USE_SYSTEM_LIB_ZLIB=1
      USE_SYSTEM_LIB_ASIO=1
      USE_SYSTEM_LIB_FLAC=1
      USE_SYSTEM_LIB_UTF8PROC=1
      USE_SYSTEM_LIB_ZSTD=1
      VERBOSE=1
    ]
    if OS.linux?
      args << "USE_SYSTEM_LIB_PORTAUDIO=1"
      args << "USE_SYSTEM_LIB_PORTMIDI=1"
    end
    system "make", *args

    bin.install %w[
      castool chdman floptool imgtool jedutil ldresample ldverify
      nltool nlwav pngcmp regrep romcmp srcclean testkeys unidasm
    ]
    bin.install "split" => "rom-split"
    bin.install "aueffectutil" if OS.mac?
    man1.install Dir["docs/man/*.1"]
  end

  # Needs more comprehensive tests
  test do
    # system "#{bin}/aueffectutil" # segmentation fault
    system bin/"castool"
    assert_match "chdman info", shell_output("#{bin}/chdman help info", 1)
    system bin/"floptool"
    system bin/"imgtool", "listformats"
    system bin/"jedutil", "-viewlist"
    assert_match "linear equation", shell_output("#{bin}/ldresample 2>&1", 1)
    assert_match "avifile.avi", shell_output("#{bin}/ldverify 2>&1", 1)
    system bin/"nltool", "--help"
    system bin/"nlwav", "--help"
    assert_match "image1", shell_output("#{bin}/pngcmp 2>&1", 10)
    assert_match "summary", shell_output("#{bin}/regrep 2>&1", 1)
    system bin/"romcmp"
    system bin/"rom-split"
    system bin/"srcclean"
    assert_match "architecture", shell_output("#{bin}/unidasm", 1)
  end
end
