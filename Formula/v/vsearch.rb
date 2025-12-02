class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.30.1.tar.gz"
  sha256 "f65f03538a77cd1212bd04a52bb722114765329e64bd35e10ee2aefcd81137fe"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "682936d6b9438e348ef258c1bf8f07655adc069ade788e4020c95f12daac9856"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe13b0567e0c4989c5173b8f66713d4ce6fc601537c60f8c39e591ce344f7eac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e106dba1bba6f22d5f1e605ec0165c9a04dbaa90a4c643ef5a33d6451f02c68c"
    sha256 cellar: :any_skip_relocation, sonoma:        "450c6c560f6489c74b918f2f8bd1f7ee07c2ec976221edf9612bf5bccfb6a11c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a22293bacfa967390daebf320e8a092430f3865aec1f829aecd1021bfe80636b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ed4b1ae0fab3422a3af92e277066246b517a2a920f86038e4eac25c3fa3ec6d"
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
