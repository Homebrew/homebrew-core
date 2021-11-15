class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://cab.spbu.ru/software/spades/"
  url "https://cab.spbu.ru/files/release3.15.3/SPAdes-3.15.3.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.15.3/SPAdes-3.15.3.tar.gz"
  sha256 "b2e5a9fd7a65aee5ab886222d6af4f7b7bc7f755da7a03941571fabd6b9e1499"
  license "GPL-2.0-only"

  livecheck do
    url "https://cab.spbu.ru/files/?C=M&O=D"
    regex(%r{href=.*?release(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "4488276aba5695c211bce6ded3078c83a14cfe376bf11fd870a2d423cd53d55d"
    sha256 cellar: :any_skip_relocation, big_sur:      "1709900ba50cdaec70d864c3b7f6c68eaa4e7396055abc6fe540e3529296d84b"
    sha256 cellar: :any_skip_relocation, catalina:     "07c4724e3a1236f19f6c9a7899077035c17501f1581838428849fc9ec8d25d78"
    sha256 cellar: :any_skip_relocation, mojave:       "6efc26bfefb204c0ed9370b2d46a2ec0e12c999b6f150d3e2a22c2d38e15d93d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aa82716b39775ce1f1a5961aad0322514723e92138f9f525db36bc389d47f694"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9"

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
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    bin.find { |f| rewrite_shebang detected_python_shebang, f }
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
