class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0270.tar.gz"
  version "0.270"
  sha256 "0364b670478883902c2bc618908192b0590235b47fbe073fcac2d13b82541437"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d0c7ee46a831e851b2787a8b08ea8ddbc93d028a474070137b6f9eb720a15ebf"
    sha256 cellar: :any,                 arm64_sonoma:  "29cd86192232dcd3f9fc32c2bf1c7786020ae3ec550e8e22feffa841b020baaa"
    sha256 cellar: :any,                 arm64_ventura: "1c51b245d105c0fd2fd1adce87776cd934e39cc7eefb8cf4b8b2c22310c8dbfe"
    sha256 cellar: :any,                 sonoma:        "65993ff76b6a7323bc8e1f80cfa7a9ee4b577d127ac4c3cf4f62a38650b5d25b"
    sha256 cellar: :any,                 ventura:       "2d656db9ede30cc18853777a5f91bce6abc31e38c1df8d87f1529c6f2a097b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d7748e0f990ebb79414dbd83129fb282a400f7426a079538f1f26085494be48"
  end

  depends_on "asio" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "sdl2"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "portaudio" => :build
    depends_on "portmidi" => :build
    depends_on "pulseaudio" => :build
    depends_on "qt" => :build
    depends_on "sdl2_ttf" => :build
  end

  # Support alternate Qt libexec directories
  # PR ref: https://github.com/mamedev/mame/pull/12870
  patch do
    url "https://github.com/mamedev/mame/commit/f1604dbe7e51f519bb98cf4c52c8b0e41184384b.patch?full_index=1"
    sha256 "42204cbf23c6a20a8b2dba515ce50e119870b5037fe224da45c53782170fb1df"
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
