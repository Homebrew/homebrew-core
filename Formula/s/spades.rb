class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://ablab.github.io/spades/"
  url "https://github.com/ablab/spades/releases/download/v4.2.0/SPAdes-4.2.0.tar.gz"
  sha256 "043322129f8536411f1172b7d1c9adfcb6d49d152c10066ccc03e86b6f615a6b"
  license "GPL-2.0-only"
  head "https://github.com/ablab/spades.git", branch: "next"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b503ed91438f312640cda43473783ba4f5499ff5c88574c58dbb0e0c07a139bf"
    sha256 cellar: :any,                 arm64_sonoma:  "fe494b9af479c627902b8e2508244b3cca845e9254ae7e2e64451c07ee606dc7"
    sha256 cellar: :any,                 arm64_ventura: "9b267ce7d7d6819ea3b8cfc0b62035581ebfa11db19ae9746c00e701a3abce47"
    sha256 cellar: :any,                 sonoma:        "f3964e9dc6ec67e93577a58034d5e3d6f819cf0914bc941e4dc7b6ad7df71b15"
    sha256 cellar: :any,                 ventura:       "7ead159556e176882ea0fcb620761bff7cf44e244789089d9840bea9d09703a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14b6d3fa8eb079fafd05061476f678027bf6bc3729f48e94b9698bb79ba8d6f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a82de520429fc5c7db797cecfbc7f2fa5aba56026d43036d35bb0ff5bc0d2cb5"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "jemalloc"
    depends_on "readline"
  end

  def install
    system "cmake", "-S", "src", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
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
