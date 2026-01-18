class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.30.3.tar.gz"
  sha256 "6ea0873fee8360b47bcad860ea1565cbfec4ed239a66f159610371d2836d5679"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dc5c6492f408d00860b0a87b07da92fe7af3b9e25fa2d328f715369c08284be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af4554b5ac28cc5ca18178156ad51b4793641fa639249ceb10651f1ac2a862a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f4ca61fffab52041bb6fd10a490536964087fb2e164cc92ccd43db54783fcee"
    sha256 cellar: :any_skip_relocation, sonoma:        "9657301969a88c76bb47aa7cad26acea31a87a40283280953d66d74194d84bcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "869730450ebecfaf33dfc9381155a61b2c0b7690e22c6e8ef99bfd392a77fe3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "969fdb69400e4f2f530c17904c8056b37cf29c95dd3b90676d9c33ebbc7b9434"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"vsearch", "--rereplicate", "test.fasta", "--output", "output.txt"
    assert_path_exists testpath/"output.txt"
  end
end
