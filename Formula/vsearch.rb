class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.22.1.tar.gz"
  sha256 "c62bf69e7cc3d011a12e3b522ba8c0c91fb90deea782359e9569677d0c991778"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fb2e3930a3fed5e89202d71ad3c479daf442b1c02b0df3b2039db0d8844c575"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86d15945c4c95ed305452c71a970b6f26b097e71ac299921717aa0528fabb378"
    sha256 cellar: :any_skip_relocation, monterey:       "0bfaf15f0c27d0d016f7dff4f06748d079f4bfb9e9d61beaaf600833737153b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf52412a64c3ce1add4ea8a1dfd78c397a15b7af7945147bdca02c7def93794b"
    sha256 cellar: :any_skip_relocation, catalina:       "65bf796bed27a063f941201b2138a144f9a6dacdff71eb99d06c701e2f56510e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "476aa8cd70419bf47c47d55c584808cc9adce17e4ebdbbb0827ce8dd0d9e10e8"
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
