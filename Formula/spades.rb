class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://cab.spbu.ru/software/spades/"
  url "https://github.com/ablab/spades/releases/download/v3.15.5/SPAdes-3.15.5.tar.gz"
  sha256 "155c3640d571f2e7b19a05031d1fd0d19bd82df785d38870fb93bd241b12bbfa"
  license "GPL-2.0-only"
  head "https://github.com/ablab/spades.git", branch: "spades_#{version}"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura:      "04556a71583e8f9a32f8eb0e68509156ceb41f801c7c67311ed5abee49c673fd"
    sha256 cellar: :any_skip_relocation, monterey:     "20789d391cc248d051c8370922326ed590944aaf6bbdd822ae9ba506f73cfdbb"
    sha256 cellar: :any_skip_relocation, big_sur:      "57f9773581ada2f7410f4b8a75e987fdb1571a95e32361780efdbec29edb9217"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ba08213dc4deed3d1ddc56d1a6a7c449c782f8eb1d5bc25fd8e6d50f356edb64"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11"

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
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
