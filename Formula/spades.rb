class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://cab.spbu.ru/software/spades/"
  url "https://cab.spbu.ru/files/release3.15.5/SPAdes-3.15.5.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.15.5/SPAdes-3.15.5.tar.gz"
  sha256 "155c3640d571f2e7b19a05031d1fd0d19bd82df785d38870fb93bd241b12bbfa"
  license "GPL-2.0-only"

  livecheck do
    url "https://cab.spbu.ru/files/?C=M&O=D"
    regex(%r{href=.*?release(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "45b237f7a9c3ee0e0f0db024dba8f9077d93502e3a451d9c203e28357efe6a1a"
    sha256 cellar: :any_skip_relocation, big_sur:      "a06c2ba0482096b9dc88db4cb010026d4d4653052513cfc848bf42a4ea392a0c"
    sha256 cellar: :any_skip_relocation, catalina:     "68f170145b2359a752ac08f50a2b374baf87a724f581060c1798b3bcbd6f01f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3b0f86d7df758b572e3560d59da2acebd70874ba0a30139b2b826ce567a2b490"
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
