class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://github.com/fabiangreffrath/woof"
  url "https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_12.0.0.tar.gz"
  sha256 "9c27250ab3289f407ca58c6500fdcb4dc3c9f70693eb42b9cead3a525e4da5fa"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_sonoma:   "272696d111b626b917191c9b2d2f01a7f6485b9e323534dc1a95833584c629d9"
    sha256 arm64_ventura:  "1435dd815bd152e47a784482e13dc5648696e110416f493846428bc5de200f3c"
    sha256 arm64_monterey: "bf211d3b9ecb07e1d0f63d86fa4b83177318280af492924e0c037a75896f7638"
    sha256 arm64_big_sur:  "f19e4e52a79f87500e103ad142f3ecec6a080eac973cd662b623aa10681ff5b0"
    sha256 sonoma:         "dc78f78bc1d3c6cf7a15d618a5796a480f52256f517faaa691104e26a572a97e"
    sha256 ventura:        "dfe29d620379a8bb2bfe992437d815ea132b5197f36057d9346de542869bd36a"
    sha256 monterey:       "425fcf2c84d2ebe2000816195a62c7ebe3fb19d46564b743b26365082194f2a2"
    sha256 big_sur:        "65b38efa006d6ecd2541e72f5ae2ebfa4cf8c3933788c33002a29c63a1684687"
    sha256 x86_64_linux:   "6a437e9062ee58685305c105012391a849f44e59df153dd19ba67b6857f60596"
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
