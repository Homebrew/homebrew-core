class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://ablab.github.io/spades/"
  url "https://github.com/ablab/spades/releases/download/v4.1.0/SPAdes-4.1.0.tar.gz"
  sha256 "997b066e157efd079f8c63229df85a9c7b81c3f626059a68669283049ab175f9"
  license "GPL-2.0-only"
  head "https://github.com/ablab/spades.git", branch: "next"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "69a44601e2610d74f2e6ee13f6d0046a36985f3c54d9c0d137e34f9db584a512"
    sha256 cellar: :any,                 arm64_sonoma:  "f507fb31ec2fb29fff6536c3822f534cbd54784c0328392ed01280cbf7d092f9"
    sha256 cellar: :any,                 arm64_ventura: "72a0885601ba7ccd4d33d012a87717d7ac534cabe4038934edf78d85327fe222"
    sha256 cellar: :any,                 sonoma:        "d7aeb7950ae594ee222349482647583010a62d4a081d444b26b0a49e7987fcee"
    sha256 cellar: :any,                 ventura:       "d62717c7f424bb42fd57d6c435c39b14ae141fb0e410e391d25146042d64a5f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12f639676a23ffde4853d73d6befda35a38bbc02e919dc44cd09e55159b2273e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7316228bf8b38afeaf0ea84a3010d973f4650f5e0a71d024d7e009c92f17e26a"
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
