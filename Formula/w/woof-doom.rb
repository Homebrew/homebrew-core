class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://github.com/fabiangreffrath/woof"
  url "https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_11.3.0.tar.gz"
  sha256 "3035b5d4d174f57067afa30721a5f1ba978a01ffa173e6a6bf691ee3cc4355fc"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_ventura:  "8e9176e9e0916b1cf2db483bd8355e9290706268131d539987f64bcb07798232"
    sha256 arm64_monterey: "827ca4c2c6cc7de418d463825625b2d69817688de5278472bdeacb42fda3bb37"
    sha256 arm64_big_sur:  "31fa2f32f2810b9f1cb9dbcce2a4f7cfedffde57575d5feb0136bdf5f74c5896"
    sha256 ventura:        "9d7072933841b5a9b4d3f918d95e2579e3507a313bc78914eedba2239707fe58"
    sha256 monterey:       "570a3fc8dbcfb08630217df365adee4e7c72e4722abe170e347b9d989f0d8c2a"
    sha256 big_sur:        "c717480c3f4d9841c0bfa9d3213839afcf12fd03357f0b4aabdb12734eff061a"
    sha256 x86_64_linux:   "b9d9871b9cb0fac8f7882f59e15e8a4735b6d8f37360685165bc130387c55597"
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
