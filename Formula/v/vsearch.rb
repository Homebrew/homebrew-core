class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.30.6.tar.gz"
  sha256 "6aa4d7f5ad07774d8e3477bc9e17a91d182f5b7f92c04e43d1bc09d539086d34"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9d97ab048b21f98f10d34633332cd4f7ef7bb8ae144f5acec1d10a421d79a53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f556c98b0410d8abba7382c23a1c0b573e112e6dc46864df1497f1ba4e440485"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "850b9af0b5c2ae2a36e3329631cf63777b1faedd8b64ba00727fca915e7d9d5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8645323241ba1c7c179374e632c7b56761e1cfd33b0d68a7614230b2c4909391"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b57e5c3339279a6a9d1775a726d5b39e49dd7136983773f5ee47108877dc881c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88c5899e1b3ddfc501327e13253bacc5a9f40899d98f36999774552dced18f66"
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
