class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://github.com/fabiangreffrath/woof"
  url "https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_14.3.0.tar.gz"
  sha256 "c19c876ae6b7cb052255c12375921f694d46bdc1b7e445a883e809f097211d2e"
  license "GPL-2.0-only"
  head "https://github.com/fabiangreffrath/woof.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "0c4358cd44eb956393fe655a38e51401c0d1641cd12479c002ca12e39927f96b"
    sha256 arm64_ventura:  "d1fe7307672c9af56684886ece175a5fbe2e715e8a3b040578e8bbdb93d5e3d2"
    sha256 arm64_monterey: "5e193fae6d3b317b978dd125de36403298a6782f4b47d1618fe82d34fb609079"
    sha256 sonoma:         "cc450493e0cf482041f6516f428dd970af159ce3c2b89a427d3403d4bb6749fe"
    sha256 ventura:        "fd74066e2237d2f8730c1f8857b0b0f85c1e0503522454fd7af0c0cb621a85bf"
    sha256 monterey:       "297b61bcbea063ebfe2d904f7250301f695f3b8991a9ef716ef3ff57e2a0a823"
    sha256 x86_64_linux:   "21d7b633f1f590e1b3af0e2bd9379fb71c55c4cf71799b35bf1db44bb15b41b2"
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
