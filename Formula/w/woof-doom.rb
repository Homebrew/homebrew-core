class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://github.com/fabiangreffrath/woof"
  url "https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_14.5.0.tar.gz"
  sha256 "1ad9e27ffeb70a60344e98f08bf17650856ffb51aa32cffd94468dacd9f1d42a"
  license "GPL-2.0-only"
  head "https://github.com/fabiangreffrath/woof.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "b36d61351eb20860130ebef15f2d351aa57c1b53a7144941ceb55c0e15954795"
    sha256 arm64_ventura:  "6512b577a17cc18d6b33892d6bcfdd4b1b39b8c97602ad6dbe0a0af00075c683"
    sha256 arm64_monterey: "e3926cf17f95f3c9e522c5780664fc7140503d58ba4b30957cb3c73d26cd5c33"
    sha256 sonoma:         "db9287960e269240a49e68e2c3b90ae29ff0dcd49ad6d059f5a2662c77a7fdc5"
    sha256 ventura:        "e2d4953664a4d0a550cb4f05df6a0694abe359722d4173d158f67b426afc2a3b"
    sha256 monterey:       "0c25e98829bb5c3c28a9fed56288f127578b245250b1b1780e97a65219236b5a"
    sha256 x86_64_linux:   "b9d8f3a75f9802616af365eb50055efa92c5278b63a436938e9d3c9b0f9bca11"
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
    testdata = <<~EOS
      Invalid IWAD file
    EOS
    (testpath/"test_invalid.wad").write testdata

    expected_output = "Wad file test_invalid.wad doesn't have IWAD or PWAD id"
    assert_match expected_output, shell_output("#{bin}/woof -nogui -iwad test_invalid.wad 2>&1", 255)
  end
end
