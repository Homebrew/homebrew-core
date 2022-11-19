class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.16.1/samtools-1.16.1.tar.bz2"
  sha256 "2fa0a25f78594cf23d07c9d32d5060a14f1c5ee14d7b0af7a8a71abc9fdf1d07"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3f0df91af76a035fcdfcafb60dc556f701b04eb28cff361a3501580658925295"
    sha256 cellar: :any,                 arm64_monterey: "38860f7c351411db8e3eb78b23206330750d88bafb7cdc2e75d7d3a60e437757"
    sha256 cellar: :any,                 arm64_big_sur:  "84ac40b23832a34b8f6a92dee46d0ab45bdd30d5ec0363acf568c9ead7f7567e"
    sha256 cellar: :any,                 ventura:        "2231b9c8d242a5e14e3118cb3992b76cd31eab5f3a57ce5521a194607a876497"
    sha256 cellar: :any,                 monterey:       "867f9b877cdcaa6b463add1a9b41eda14f20cf66ba4fe73ce00c405e1310b081"
    sha256 cellar: :any,                 big_sur:        "5c49374e4eb83be2be7e6254086c66b4e1c5d9ad270938f8a45f0bdde1f32346"
    sha256 cellar: :any,                 catalina:       "298a55bff49d78150c34c540254a36eb8474ae7074a96a6ade1ee59be62777a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ca3c73d28cd214b8595eef79f72c7c0069009e126eefa099e584684a9ddd82e"
  end

  depends_on "htslib"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{Formula["htslib"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"samtools", "faidx", "test.fasta"
    assert_equal "U00096.2:1-70\t70\t15\t70\t71\n", (testpath/"test.fasta.fai").read
  end
end
