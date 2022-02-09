class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://cab.spbu.ru/software/spades/"
  url "https://cab.spbu.ru/files/release3.15.4/SPAdes-3.15.4.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.15.4/SPAdes-3.15.4.tar.gz"
  sha256 "3b241c528a42a8bdfdf23e5bf8f0084834790590d08491decea9f0f009d8589f"
  license "GPL-2.0-only"

  livecheck do
    url "https://cab.spbu.ru/files/?C=M&O=D"
    regex(%r{href=.*?release(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "b9da94286c55d210de91d60327d8853b6d6f5a3f5696d826bff7796db5221584"
    sha256 cellar: :any_skip_relocation, big_sur:      "c14663b2aa9502bece0210c2563ce6c9cc00586625f090accc59278611ba3e24"
    sha256 cellar: :any_skip_relocation, catalina:     "fcf3d8860c032d7402115b9c16be93056a7ecd9d1b3f328fa8be825b7e1b62fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c1fa79f789782f57ea36e5afa4b020a94aa0ec746d181e20083665166bd05682"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10"

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
