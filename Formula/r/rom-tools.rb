class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0259.tar.gz"
  version "0.259"
  sha256 "46baf431079a3373ffe8d984b3ba5d62ad5b1d5e356d1f60cf60f6ad03d4cec6"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  livecheck do
    formula "mame"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "37391a21e8904cfa1b50d7772ac7250e0d9f6717edff9ec2e1e221d77cdcfc08"
    sha256 cellar: :any,                 arm64_ventura:  "3dc34b6a073c04105c0eccb06d7ce0069b817da34aa315facced1785c8dd92af"
    sha256 cellar: :any,                 arm64_monterey: "3a6c39d1e3b771e3d302768e65d1262bbd1eb89a328bdbb4847b0e045744a09b"
    sha256 cellar: :any,                 sonoma:         "0a9d9744dfd984da8df9a69c83bc2a92a21f1f2fd7b3cc570868275fa1b4439e"
    sha256 cellar: :any,                 ventura:        "6468a2859cf73c26b7346344708d71e74c1d420249afe1da2c211b3e9ca60f64"
    sha256 cellar: :any,                 monterey:       "e7c11296ea8e171932bf60c5179bf6f3acdefd8d780a0917cacc631d7ded18a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e612203e0b183672a86b688e644fa179357aeaee07028a6c5aef32cc8e2df02b"
  end

  depends_on "asio" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "flac"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "sdl2"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "portaudio" => :build
    depends_on "portmidi" => :build
    depends_on "pulseaudio" => :build
    depends_on "qt@5" => :build
    depends_on "sdl2_ttf" => :build
  end

  fails_with gcc: "5" # for C++17
  fails_with gcc: "6"

  def install
    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    args = %W[
      PYTHON_EXECUTABLE=#{which("python3.11")}
      TOOLS=1
      USE_LIBSDL=1
      USE_SYSTEM_LIB_EXPAT=1
      USE_SYSTEM_LIB_ZLIB=1
      USE_SYSTEM_LIB_ASIO=1
      USE_SYSTEM_LIB_FLAC=1
      USE_SYSTEM_LIB_UTF8PROC=1
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
