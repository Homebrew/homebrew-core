class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://ablab.github.io/spades/"
  url "https://github.com/ablab/spades/releases/download/v4.2.0/SPAdes-4.2.0.tar.gz"
  sha256 "043322129f8536411f1172b7d1c9adfcb6d49d152c10066ccc03e86b6f615a6b"
  license "GPL-2.0-only"
  head "https://github.com/ablab/spades.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ec418aef4f38a7b784b9dfe700f499442c54f486b86465888fb0ca1baf8767b9"
    sha256 cellar: :any,                 arm64_sequoia: "336e4711b7e792297dd05b0051046da1a98b571b4e558bfceb4de0e493f2efed"
    sha256 cellar: :any,                 arm64_sonoma:  "9fa28c167e3eb14b53ac5d411b2b34215a4981ef79a2e50593678bdea7a88998"
    sha256 cellar: :any,                 arm64_ventura: "de12ae30dd5eda9126877cc8277d7afeb5e7d99571e133463a4a5bff6686c55e"
    sha256 cellar: :any,                 sonoma:        "9d3e91551f652b76506b3bf66de0993e88d5a52837657ed872ed02383802bdb1"
    sha256 cellar: :any,                 ventura:       "1d291e5b823b27f0e9ffa5d3d31f15a3ac9cc4812e5b80a05686daabd712be3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "006fd83128b54085519a5b88843db9f27aa25cb1cce3830cf3e1e703fc64334d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a487ef4a83f4d7238fcd6560c1085144357a17d25609e6165b946e4e1bfd4040"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13"

  uses_from_macos "bzip2" => :build

  on_macos do
    depends_on "libomp"
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
