class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.20.0.tar.gz"
  sha256 "450254695daf747e80bfc2665a6467d702eeab8f73f6008aed2bba94ddbf7dd4"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d650a1688c51b8342f3c1377c0bbf15e70ea8671ea1894952c6f0f4955bd37b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e868227ea7310388d437a7512d89b4b3e01a466f168e01f924fb48640f5a97e"
    sha256 cellar: :any_skip_relocation, monterey:       "ed29dc48730e5eff451d0ff077d0e81a80cbd4a238922ba8e0b2b1cedc23dbc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7563a8abc26edd69dbbb1704aa702385c5925cd72e3c3177eb73ec49bab1201f"
    sha256 cellar: :any_skip_relocation, catalina:       "f68a81a840b6684d83e6497b87103278a037c859dfc12f06035f73b606dec778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a992ff5bd5edb9c83ad9d2fd969062ecdceb9ded4db23c912e11cd6ccc58789"
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
    assert_predicate testpath/"output.txt", :exist?
  end
end
