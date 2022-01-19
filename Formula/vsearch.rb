class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.21.1.tar.gz"
  sha256 "0c5f4c981bc8ecbf23ee618d1b45667f81ae9845d64b9d6a310edbd196c84638"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98178b8cc7c1ec4d834522a787ba26d6fbc26cd69fd7ec6975023dbf7796ef90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e6086956a1cfc570b936eb8a0309056756cab2ba3a4ff97f8fdaf05ad3c03ad"
    sha256 cellar: :any_skip_relocation, monterey:       "0e761ab18bb0cc4c071fc47886fccb3420b1e3b47eac237213acc1c86f6e7d41"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3b6ddede71d48671e1e269f2ab41b5cfc3babd26a7b270343004d1df551959b"
    sha256 cellar: :any_skip_relocation, catalina:       "eaff4a99f65ea8bb1b84765e8b943dfadafdfc370bf050df18db0856c718e523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c512c20085b725594c561f6e6157b4b77a0cdab6418a1962e4fe07aea960fbf7"
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
