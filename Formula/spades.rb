class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "https://github.com/ablab/spades/releases/download/v3.14.1/SPAdes-3.14.1.tar.gz"
  mirror "http://cab.spbu.ru/files/release3.14.1/SPAdes-3.14.1.tar.gz"
  sha256 "d629b78f7e74c82534ac20f5b3c2eb367f245e6840a67b9ef6a76f6fac5323ca"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c2a3bcd1c2b83517676f45d3381b72e4644beeb98af2add918d8b30271eb8012" => :catalina
    sha256 "a3074628545245497991275ef869a42fa30b465f523fc63c69c37fecdc5e4349" => :mojave
    sha256 "c6d252bcbfe704a634cfbd929d87c003f1c2023abab767db6cd04e2c778c227b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "python@3.8"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
