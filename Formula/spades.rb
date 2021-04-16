class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://cab.spbu.ru/software/spades/"
  url "https://cab.spbu.ru/files/release3.15.2/SPAdes-3.15.2.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.15.2/SPAdes-3.15.2.tar.gz"
  sha256 "e93b43951a814dc7bd6a246e1e863bbad6aac4bfe1928569402c131b2af99d0d"
  license "GPL-2.0-only"

  livecheck do
    url "https://cab.spbu.ru/files/?C=M&O=D"
    regex(%r{href=.*?release(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "34af086650bb5899077627835d762cfefbf3eb91c455cd5b06366a66f79ce9f4"
    sha256 cellar: :any_skip_relocation, catalina: "a8b73043b7c26aa1279b91345022ac31446498af30624562fc2d925097d84cc4"
    sha256 cellar: :any_skip_relocation, mojave:   "a8afd9fcf696ec82d6faefb29b79751a930eabe8dbf19df053fb1c36a780d6bd"
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
