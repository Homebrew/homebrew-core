class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://cab.spbu.ru/software/spades/"
  url "https://github.com/ablab/spades/releases/download/v3.14.1/SPAdes-3.14.1.tar.gz"
  mirror "https://cab.spbu.ru/files/release3.14.1/SPAdes-3.14.1.tar.gz"
  sha256 "d629b78f7e74c82534ac20f5b3c2eb367f245e6840a67b9ef6a76f6fac5323ca"
  license "GPL-2.0"
  revision 1

  livecheck do
    url "https://cab.spbu.ru/files/?C=M&O=D"
    regex(%r{href=.*?release(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a6f57aca314cbe6d46554308a1b6a54c6c76bab341ac0813e9d0e68187428023" => :catalina
    sha256 "0f536b922fba137fca8f2ba6634a90fc09e71b683342a0d331ac2bd1676d5fac" => :mojave
    sha256 "c2bc400de41d30e04ad78cdc1894a5c9af1a15a237ae6aa71d73d2807b93e029" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8"

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
