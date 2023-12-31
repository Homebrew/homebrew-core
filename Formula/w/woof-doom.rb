class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://github.com/fabiangreffrath/woof"
  url "https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_12.0.2.tar.gz"
  sha256 "b7babd807225cafcf114cad8aff4bcbe8fda773dde1842b1b19ab32a164b82e9"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_sonoma:   "14c05a04400517c9398fa76948b7716a0c8157c62da690fc09bf45874661ddc3"
    sha256 arm64_ventura:  "33216a1433be534e0f34b7527d79c2dde3a4998cbb81debe43ae39bb7dea6505"
    sha256 arm64_monterey: "1167da8f8dab2e7a86c0fd9717274ee53cc735afa1d162bbc3433681c347dc32"
    sha256 sonoma:         "647b99778d883e1d09ab09bb3c9551386f3feb922feed772ac25005d36e0fe4a"
    sha256 ventura:        "7b0ed205a59c04ef0bbbff5fd713ac13450f91bed39aeff02658546944b76eef"
    sha256 monterey:       "e9ba585f2c3ad655bae18c6c4c1a634e59bb47d4a4b34ef47868246f6777d005"
    sha256 x86_64_linux:   "d49ad6bc5091db57c2afb55dd03fa7715c248c2232f01375fa5cc08e676cf157"
  end

  depends_on "cmake" => :build
  depends_on "fluid-synth"
  depends_on "libsndfile"
  depends_on "libxmp"
  depends_on "openal-soft"
  depends_on "sdl2"
  depends_on "sdl2_net"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected_output = "Woof #{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}/woof -iwad -nogui invalid_wad 2>&1", 255)
  end
end
