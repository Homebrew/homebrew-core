class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://ablab.github.io/spades/"
  url "https://github.com/ablab/spades/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "6ed35f1c9ca7eedab2b1bdb7437b6dccf3cf5a5e8373ff4c28ce2d08d8a82954"
  license "GPL-2.0-only"
  head "https://github.com/ablab/spades.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bdf15913e69de45277657602d31a5137582d99df0356e0f814b12eab9f1d65e8"
    sha256 cellar: :any, arm64_sequoia: "7c9c3ec945f3782af3e992a316679e343c4fe38dcb3b761a0da30614c145edab"
    sha256 cellar: :any, arm64_sonoma:  "84af7394f22ced50172d792c4b4edbd19ce2d78f530fe2747400804a78baa586"
    sha256 cellar: :any, sonoma:        "1013ee0e0487a8df50f53b1ec4ee12b5b1e966355da68f1e0673f6ec4033cf4e"
    sha256 cellar: :any, arm64_linux:   "e49853f710c9f5eda53e227c76249c1bad24be496f91da4fb6398493b5980f1a"
    sha256 cellar: :any, x86_64_linux:  "f5424a99aa7f201e5114b940c56c5f112c071b1eecbb4169ae39b626866603a1"
  end

  depends_on "cmake" => :build
  depends_on "python@3.14"

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
