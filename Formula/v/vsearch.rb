class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.27.1.tar.gz"
  sha256 "54666bcd9434fb7636c5b292a67e7c194e809e631bbe8f4f86b85fb47e863abc"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9797722dedf3ff2e64131de9bb10cd28e1f5589399daf95338fa6107e349f4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84db63f523609b6a914de62b064ba55cd32a4a0799a72b0163e511ea3100dbae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75b65770c4622333421ec8dec3bbc22295403e9accaa74f0bfc245344aad0efc"
    sha256 cellar: :any_skip_relocation, sonoma:         "b86db621822001238c6f728c079da9f35c2b37ee1e6b9ea148fdd231fbb7dbce"
    sha256 cellar: :any_skip_relocation, ventura:        "1c273830865681b3be02a5b6eec2ccd6c6a19d90d238556ac89a6e23ab55949a"
    sha256 cellar: :any_skip_relocation, monterey:       "5eda922052cb2db63b335b24e7a19c5539ec81930671ccaa5536620fdf292411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "949a893b646b5c8cc02b18b66a41b8313674f08a3c091f6e26112c61fd96d1f2"
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
