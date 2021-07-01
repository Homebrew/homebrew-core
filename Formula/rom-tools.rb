class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  # NOTE: Please keep these values in sync with mame.rb when updating.
  url "https://github.com/mamedev/mame/archive/mame0233.tar.gz"
  version "0.233"
  sha256 "ea7fc31a4b839bb99c94a59810eb6691ce88dbc2b6d78cf6a48ca776a46a83a9"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git"

  # MAME tags (and filenames) are formatted like `mame0226`, so livecheck will
  # report the version like `0226`. We work around this by matching the link
  # text for the release title, since it contains the properly formatted version
  # (e.g., 0.226).
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{release-header.*?/releases/tag/mame[._-]?\d+(?:\.\d+)*["' >]>MAME v?(\d+(?:\.\d+)+)}im)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "883d1418429d3d3f6051f5b4a8277548f99416644b7a22bc43b744858b1ad1e4"
    sha256 cellar: :any, big_sur:       "aaefe2769fcf9a9e393fa128d1b718af8b27eb0cc781da2801fdcfbf0907555e"
    sha256 cellar: :any, catalina:      "085b20146f49a42c4cff9270cd9a8a11781012cb43b9d8507c45b0601bbc8c21"
    sha256 cellar: :any, mojave:        "6e359f8b65d73fdee546ab4a4f697ad8d12a5c6230609a3c64ed31a23535cf4f"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "flac"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "sdl2"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Use bundled asio instead of latest version.
    # See: <https://github.com/mamedev/mame/issues/5721>
    system "make", "PYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3",
                   "TOOLS=1",
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_ASIO=",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1"
    bin.install %w[
      aueffectutil castool chdman floptool imgtool jedutil ldresample ldverify
      nltool nlwav pngcmp regrep romcmp srcclean testkeys unidasm
    ]
    bin.install "split" => "rom-split"
    man1.install Dir["docs/man/*.1"]
  end

  # Needs more comprehensive tests
  test do
    # system "#{bin}/aueffectutil" # segmentation fault
    system "#{bin}/castool"
    assert_match "chdman info", shell_output("#{bin}/chdman help info", 1)
    system "#{bin}/floptool"
    system "#{bin}/imgtool", "listformats"
    system "#{bin}/jedutil", "-viewlist"
    assert_match "linear equation", shell_output("#{bin}/ldresample 2>&1", 1)
    assert_match "avifile.avi", shell_output("#{bin}/ldverify 2>&1", 1)
    system "#{bin}/nltool", "--help"
    system "#{bin}/nlwav", "--help"
    assert_match "image1", shell_output("#{bin}/pngcmp 2>&1", 10)
    assert_match "summary", shell_output("#{bin}/regrep 2>&1", 1)
    system "#{bin}/romcmp"
    system "#{bin}/rom-split"
    system "#{bin}/srcclean"
    assert_match "architecture", shell_output("#{bin}/unidasm", 1)
  end
end
