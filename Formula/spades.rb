class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://cab.spbu.ru/software/spades/"
  url "https://cab.spbu.ru/files/release3.15.0/SPAdes-3.15.0.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.15.0/SPAdes-3.15.0.tar.gz"
  sha256 "6719489fa4bed6dd96d78bdd4001a30806d5469170289085836711d1ffb8b28b"
  license "GPL-2.0-only"

  livecheck do
    url "https://cab.spbu.ru/files/?C=M&O=D"
    regex(%r{href=.*?release(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "85776ce52d23b7bf4fb0e9ecdd8bce77c722706a662b677ad74b13b62e43c8a3" => :big_sur
    sha256 "4e80e0f7e271b2653d6fc9d425d3623096f349ab582f1f03e223c7ce815a4b5c" => :catalina
    sha256 "e182a129f1519391ba6267c36eb1f6bb08df89edb33b0c4edb3c7473dad17791" => :mojave
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
