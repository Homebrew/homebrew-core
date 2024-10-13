class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://github.com/ablab/spades"
  url "https://github.com/ablab/spades/releases/download/v4.0.0/SPAdes-4.0.0.tar.gz"
  sha256 "07c02eb1d9d90f611ac73bdd30ddc242ed51b00c8a3757189e8a8137ad8cfb8b"
  license "GPL-2.0-only"
  head "https://github.com/ablab/spades.git", branch: "next"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "36804b795a1a9d5a7b60414c8d4b46ff6bcdbcd9d9e74771170bb9b05e635892"
    sha256 cellar: :any,                 arm64_sonoma:  "40c88655fd60c534ae6988c153b5e609aca9642612a30d5afb9ef7e014d50b5e"
    sha256 cellar: :any,                 arm64_ventura: "6421a91f79aa8f03c5dfd76e07562fe92e21c33d1cd136ebc08abc6883991587"
    sha256 cellar: :any,                 sonoma:        "3c740b96b14eeb5fc184cb8186c0d7a5ebc829d40c1ab04eaa7843a30a6d0853"
    sha256 cellar: :any,                 ventura:       "582d300f360e60ce1d683dda845193ee256a1513ebdb42814bc81f55e2fb05b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fc9c195a2edf4522a54b55a96d66859c8e68d2e69dba7cdec98f53dfd14b37f"
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
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
