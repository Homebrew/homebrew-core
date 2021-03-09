class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://cab.spbu.ru/software/spades/"
  url "https://cab.spbu.ru/files/release3.15.1/SPAdes-3.15.1.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.15.1/SPAdes-3.15.1.tar.gz"
  sha256 "db0673745459ef3ca15b060bf9cff9aa1283823f8b3ed9e07b750d1d627d6249"
  license "GPL-2.0-only"

  livecheck do
    url "https://cab.spbu.ru/files/?C=M&O=D"
    regex(%r{href=.*?release(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d191c07412dfdb3076d4063e3f9617f6bcd6eb80eaf91bcdbd30834aca640f29"
    sha256 cellar: :any_skip_relocation, catalina: "4c5e6f77073346ab9b4c6e94dd388fdd0f9986d0f0b8249294df00a82b3ad166"
    sha256 cellar: :any_skip_relocation, mojave:   "ec1de888a347d60dd9459aa0915b41b25170adaf610369e7f95645dd23d5b63b"
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
