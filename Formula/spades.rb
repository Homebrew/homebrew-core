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
    sha256 "546178729abf59e60a8493665da0ccdde14f703c5540e08efcaa92b0dd3d8527" => :big_sur
    sha256 "d71dce85beb2f8f912c630e9a7275295f0cb88f6e35ae9b3e6ef5fcb9038a082" => :catalina
    sha256 "3d5353e4e5d69fb611873ee7ba7cd272f61b2f306515efc10762ee6e65d4e2bb" => :mojave
    sha256 "0d219b76bb4076f76f1a7551b06620258702dee5229685a85b5ec683e6dbb3ab" => :high_sierra
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
