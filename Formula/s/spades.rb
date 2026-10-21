class Spades < Formula
  include Language::Python::Shebang

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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "9b10dd3d6fb5e845b8ec7d6c82ef6dd5429215939080f971991958e6bcc3df12"
    sha256 cellar: :any, arm64_tahoe:       "6f043968584261307908fa06256d777c2d24afac9c8b2aea09cb9a86299d0eab"
    sha256 cellar: :any, arm64_sequoia:     "a6c2383c796a629e2bf18a42c495351c6e4efa834c82dd765d94fd15a8301fad"
    sha256 cellar: :any, arm64_linux:       "127fd223b1eca5ec7a6e3513b93ce1f26c8b37427c9703357c648114ea8cfa2f"
    sha256 cellar: :any, x86_64_linux:      "2ca5c3b8032572072be3a889c7b357c3f518a3ecca2dd7d34a6e824b59bd3788"
  end

  depends_on "cmake" => :build
  depends_on "python@3.15"

  uses_from_macos "bzip2" => :build

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
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
