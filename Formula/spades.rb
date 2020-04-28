class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "https://github.com/ablab/spades/releases/download/v3.14.1/SPAdes-3.14.1.tar.gz"
  mirror "http://cab.spbu.ru/files/release3.14.1/SPAdes-3.14.1.tar.gz"
  sha256 "d71ce756daa0a889b8881bd129a761200a0bb971e6fd2bed1384a1df9b585d1b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4f619fb90d37233f7fadbba8c9fa30b039145fc93a453a1381dc6386b0e4b2d3" => :catalina
    sha256 "e48a5ee1e9836f3185985e074891a485a14096148babadee818354d0b34a2bdf" => :mojave
    sha256 "b7ab0e7eeaf9f1e48e2b3c54150bea4bfc1322badaf41237bdfc49e8d435e5d7" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "python@3.8"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    Language::Python.rewrite_python_shebang(Formula["python@3.8"].opt_bin/"python3")

    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
