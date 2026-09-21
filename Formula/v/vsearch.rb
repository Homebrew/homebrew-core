class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "aa6fecd099ba4970b2685e41e3a97e04f1317d12cb315870e3acdc1cd6b7fe5d"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9a8f655e759d0ef6bc24b8dc0adaab8aa79a40da62c4408ff4d353216bf6811"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57f6c1041272d2574437ce2b415effa71f9ccbec56eddb6f72e8c7a54e8884e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0976ccafbd99ba2287ba158c84f19d92817c39159e0c5ce021eafe1be6367dc1"
    sha256 cellar: :any,                 arm64_linux:       "9af532086b082b4c3a6a8da13092b349d6aab1c7607ee07249e6cc9b63db8762"
    sha256 cellar: :any,                 x86_64_linux:      "af2ad999a464f9d85e7e5df26ab10d2e131028b82ed588169f88b8139e0dc03e"
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
    (testpath/"test.fasta").write <<~FASTA
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    FASTA
    system bin/"vsearch", "--rereplicate", "test.fasta", "--output", "output.txt"
    assert_path_exists testpath/"output.txt"
  end
end
