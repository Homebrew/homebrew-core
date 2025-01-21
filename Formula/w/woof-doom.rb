class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://github.com/fabiangreffrath/woof"
  url "https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_15.1.0.tar.gz"
  sha256 "ee88668fd3c038bd5b1c144d663dadae3afb16ed997c2b660e47d4f6b3a006d7"
  license "GPL-2.0-only"
  head "https://github.com/fabiangreffrath/woof.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7ae0af569590d44c5afe343ea6cb48b8c7ba41efb5a32b80d0e24206c0edafaf"
    sha256 cellar: :any,                 arm64_sonoma:  "a0a47bea8d52e73640436d4aac5460c7ef81b81544e09669de8da2959b80b9cb"
    sha256 cellar: :any,                 arm64_ventura: "80b0c5dbf379da793eb2235d60df56b291092b356a88e3f54e6225d909d714c4"
    sha256 cellar: :any,                 sonoma:        "88d7e88b43f987abba5fc0c8a23ee01566624f9e8c0f276e646fbbcaa6c8f67c"
    sha256 cellar: :any,                 ventura:       "570cba51df33954ed527df5ff73e3ac6749deb1166e4a8c06de003def4b340a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2386f22a1f06b6696075ef7e5f573720846ae5c9303c92c3a04b7f9fcfdc914"
  end

  depends_on "cmake" => :build
  depends_on "fluid-synth"
  depends_on "libebur128"
  depends_on "libsndfile"
  depends_on "libxmp"
  depends_on "openal-soft"
  depends_on "sdl2"
  depends_on "sdl2_net"

  on_linux do
    depends_on "alsa-lib"
  end

  conflicts_with "woof", because: "both install `woof` binaries"

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

    expected_output = "Error: Failed to load test_invalid.wad"
    assert_match expected_output, shell_output("#{bin}/woof -nogui -iwad test_invalid.wad 2>&1", 255)

    assert_match version.to_s, shell_output("#{bin}/woof -version")
  end
end
