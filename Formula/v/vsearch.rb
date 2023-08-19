class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.23.0.tar.gz"
  sha256 "4686e35e1d8488ffedb4c6dd4de9b6eccc94f337d7b86e1759d932bce59c9b64"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cd34cdfd0df01d89db2a8ca48d40b62604c1726c67231369d5e30ae439bbfe7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb170ea1b5cd39df12684f5317f8ffa1d5588ee01151a2cf1c11f510d993b9bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6326666ccd2a571bdda83bf8e2f07478ff6893a3be0e04880bc420ec2a29236"
    sha256 cellar: :any_skip_relocation, ventura:        "f5bb7f3cbc70a4640c03474a1b1d5580c3a7779865125e2d1219f4fe2a5f450f"
    sha256 cellar: :any_skip_relocation, monterey:       "d92bff5726a0ef0a076bc3bec5d27928cc61f65224748003770df66ac8522fe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3321de5da8231f5955666a13e020dddbec01eb6eeeb545aba0301a15e6ed0190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eea74ba949865ea174e1b79844d0ae84451881bb43911bc281b45f4759d03742"
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
