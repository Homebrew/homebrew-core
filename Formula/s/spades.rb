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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "dfb1b8e8a099823127b97e10c3cf6951b71fa135cbab935f82ebf4beb5fc4bd7"
    sha256 cellar: :any,                 arm64_sequoia: "4434b0f70adbcc1995b80975edf1d35b0e171524f89e2de496e66cd664090407"
    sha256 cellar: :any,                 arm64_sonoma:  "787fc89b652698b3610ecfde765de7dfb947a0517e5cd4ff35345303561fad21"
    sha256 cellar: :any,                 sonoma:        "5c7ce0aa451474c9cb40dfaf9ea5d7d4331dafb3304eb3586e2fea88d3330a61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c9ee246e19db295757ed9cbf2b4f3b75d2476620778e28411feae289bc7ed34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56929dd62ca2109f9194096c04452dbe7f572a9858cdc54d1fbeeb7743af4563"
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
