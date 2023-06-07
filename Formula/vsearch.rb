class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.22.1.tar.gz"
  sha256 "c62bf69e7cc3d011a12e3b522ba8c0c91fb90deea782359e9569677d0c991778"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bda0ab83f9e19c237c07fd3f79c13cf2b57190baccb3b0f2a83e78dbe79e445a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26458ebd854652a1a8ad1bc9a421ecbff3eb4d18bbfeb04bc563d7a3155fc60f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ef50f6a561e90fa600581990f92a3b5f5eda98317efd98ad1686b780c9ba090"
    sha256 cellar: :any_skip_relocation, ventura:        "40025c3e74d6749c5fd2726cf768e03a2429a2ecc10bbca1d7ba2ecdbb0d6f93"
    sha256 cellar: :any_skip_relocation, monterey:       "9df313961a9e2cb3e85acb461084c9cfdf821f8cec37762b630607e9146c9b07"
    sha256 cellar: :any_skip_relocation, big_sur:        "66713897d8f2429e1c1be48ee534fba592c667909110e4947fac259bdd575219"
    sha256 cellar: :any_skip_relocation, catalina:       "4220e7dfa2cab712bc77941540850043c87286c8dd1cb8112beed5c69e4f5448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77032d2419ab4063cfcbfdb199b9bf0a54bc5b4087c77226c334817c12d98896"
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
