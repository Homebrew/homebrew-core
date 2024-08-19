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
    sha256 cellar: :any,                 arm64_sonoma:   "4211f7c49c9f9b896aba38958fd60c9aa340055362222c5b1b91a96c6d8b1186"
    sha256 cellar: :any,                 arm64_ventura:  "b7648468fbc39495eae7723bb527af748e863bbff65a0d4341cb5ec8035226f3"
    sha256 cellar: :any,                 arm64_monterey: "09c312987910e391deaa36ab11a7823ada78074944af6ffcb73b46d6a02006fa"
    sha256 cellar: :any,                 sonoma:         "4a8945bcd33c7c1c04fa1c538bb6230d4a60f10a71aa4bf5559da15a80d2c9d4"
    sha256 cellar: :any,                 ventura:        "74edae7cf86ef64da79d13d6fa3cde7a4163f76c25b02cb3a7d2596a467f7363"
    sha256 cellar: :any,                 monterey:       "294e9d7c5f60ea7fdcd36a0e495f3b1f5c12e835b7d16a5532823180978241e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76478d4ca675a86ece42168bb01720f63e28c273ca8236205bd1451f11c2d175"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12"

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
