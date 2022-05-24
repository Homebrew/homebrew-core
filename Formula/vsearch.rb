class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.21.1.tar.gz"
  sha256 "0c5f4c981bc8ecbf23ee618d1b45667f81ae9845d64b9d6a310edbd196c84638"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60a20c7db97a19480746b217c1a643b9c90eaa51a5d5110dd52480eb06095795"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a99ee1fab49d2944c45ae3fb00c0cff2a1a36ba3a37c0f06be93da28751b821c"
    sha256 cellar: :any_skip_relocation, monterey:       "0da32c55eab32b73ed9f83c39ecf3011a48d4595ac0d05738bece1ca886bd062"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4c87b86a29ea3742201d9764adc5ebe483f0c0243ddba9de78595a6e1bda3d6"
    sha256 cellar: :any_skip_relocation, catalina:       "1b158f098827a1a39f0707159d26d89597312a23f99af7b33fe5aa44660ad633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef5e9bd90a710ba412c06f420680c855c27663d7f91fa9c205adae4db7a8ca72"
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
