class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://github.com/fabiangreffrath/woof"
  license "GPL-2.0-only"

  stable do
    url "https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_15.3.0.tar.gz"
    sha256 "ace929952479bf42f2bbf404f6bc95ca5fabde23f3c8d656c6d1339b9baebbcc"

    depends_on "sdl2"
    depends_on "sdl2_net"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5fe5942382f6b24dfd928f023279f36ea7fc8686a92affbfe9dac93d4df6ea50"
    sha256 cellar: :any,                 arm64_sequoia: "9af289e62db9550c0d9d04903f596e46f0ab67a3fe7d42fff1294511549b6fa9"
    sha256 cellar: :any,                 arm64_sonoma:  "eefa1a71e7e29f5a19ee0f50f6332ac37d1334d2b6c72e09eddeb9e9dd2de9a8"
    sha256 cellar: :any,                 sonoma:        "ce1a252768cd9d70a653330c55b3fc53b8a8c922d15fd7184d36561e2403a48a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f97536230d32c3733dbee65719503d45d620112ab004de741542f1c125e193f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f25b3b170b7b2b6bd627f551ea0dd4fe229898bf039a72508a441fd1ecf4ca6"
  end

  head do
    url "https://github.com/fabiangreffrath/woof.git", branch: "master"

    depends_on "sdl3"
  end

  depends_on "cmake" => :build
  depends_on "fluid-synth"
  depends_on "libebur128"
  depends_on "libsndfile"
  depends_on "libxmp"
  depends_on "openal-soft"
  depends_on "yyjson"

  on_linux do
    depends_on "alsa-lib"
  end

  conflicts_with "woof", because: "both install `woof` binaries"

  def install
    # Remove bundled libraries
    rm_r("third-party/yyjson")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test_invalid.wad").write <<~EOS
      Invalid IWAD file
    EOS

    expected_output = "Error: Failed to load test_invalid.wad"
    assert_match expected_output, shell_output("#{bin}/woof -nogui -iwad test_invalid.wad 2>&1", 255)

    assert_match version.to_s, shell_output("#{bin}/woof -version")
  end
end
