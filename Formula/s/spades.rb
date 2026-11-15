class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "https://ablab.github.io/spades/"
  url "https://github.com/ablab/spades/releases/download/v4.3.0/SPAdes-4.3.0.tar.gz"
  sha256 "09671ca39f9c6d2479d9fc168100bfd089b4a24002d51b815386d2b24d424456"
  license "GPL-2.0-only"
  head "https://github.com/ablab/spades.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "bc023cc6a6e515dd2e5b5335c6c13279895b52008a1ae5d58682eb4ed6599be4"
    sha256 cellar: :any, arm64_tahoe:       "23f74bb027e00eb1c5bf5bb12a71f9ea4228257f0d980e7f462d16db686b4324"
    sha256 cellar: :any, arm64_sequoia:     "64032958f2f0b98b745dbee488462fcfdca052272174d35928e5a16810b3c531"
    sha256 cellar: :any, arm64_linux:       "e3cb82ef812c93aac69829c1fe953dedb870a5bef711dd3ef962e77a60d36f0e"
    sha256 cellar: :any, x86_64_linux:      "4381febf9c5cd6ad5f280e647a8c55966b88911b5e536a9b66d9b4d90c96d397"
  end

  depends_on "cmake" => :build

  uses_from_macos "bzip2" => :build
  uses_from_macos "python"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    # Build bundled zlib-ng with runtime detection
    with_env(HOMEBREW_CCCFG: ENV["HOMEBREW_CCCFG"]) do
      ENV.runtime_cpu_detection
      system "cmake", "--build", "build", "--target", "zlibstatic"
    end
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
