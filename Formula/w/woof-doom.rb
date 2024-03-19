class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://github.com/fabiangreffrath/woof"
  url "https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_14.3.0.tar.gz"
  sha256 "c19c876ae6b7cb052255c12375921f694d46bdc1b7e445a883e809f097211d2e"
  license "GPL-2.0-only"
  head "https://github.com/fabiangreffrath/woof.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "29c3b691fbd2060f0f443fbe730c2b8cf4b86839c43f8ad02079d6426988b41e"
    sha256 arm64_ventura:  "2d1c48b61cc10739d9335b55e6a7db0437db4e8e8a43a116d4e3421bdfd9032a"
    sha256 arm64_monterey: "22814db8feb186af74c72bdb6ed27a91e95cdce013db327a7e8dfb1243dd1c6e"
    sha256 sonoma:         "a96a066c3108564f61085cd4662eccb73f7e403388c0333044ac8db8384e368f"
    sha256 ventura:        "8861ed14c8d7ae500772c42ece95bd1698e8cbac13e4dfbdb8eaee89e4f5b83e"
    sha256 monterey:       "3dea1479ae976390c5ad050e20d04010ecac761ce764d5f822386351f2565b64"
    sha256 x86_64_linux:   "d173fa89ae1fe8e7246d1bf5a14d3d2f210104ef1bcda6fdb3abe43163172748"
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
