class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://github.com/fabiangreffrath/woof"
  url "https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_15.2.0.tar.gz"
  sha256 "aa2842c2897b1a8c733a79db190c2e6c17cef10651c5cd5105c7bf1360799932"
  license "GPL-2.0-only"
  head "https://github.com/fabiangreffrath/woof.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9f0b9979cbb09840542e15f524abb725a5531e1c10b7d4bbcfc9333096acd39d"
    sha256 cellar: :any,                 arm64_sonoma:  "5cbd903199d7c932b11e369c48ed666f975f54f7e0095d8d282827a16215f370"
    sha256 cellar: :any,                 arm64_ventura: "ecb8f5469dc35e84049fa7ba8fe21548f16c12374fd883503fe301dc8d69e5bc"
    sha256 cellar: :any,                 sonoma:        "1a0bb7a3fc9683e6d515d68e18132f7cab5e1b5815e75adf7144869e6078a4c0"
    sha256 cellar: :any,                 ventura:       "9bd1b3c7acae2ef026e6d701aaf6daff8037ee9f4477c7a2d207b0403f7e3dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dacc4a1a6f973620fc386939b682a9727ddbc26759d8484cfa1a56fe5c815d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65ec9fc0998e63cc399282a54cc1cdd7f3dd4c676907cc6ed377ad0af0bbd898"
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
