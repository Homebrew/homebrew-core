class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.28.1.tar.gz"
  sha256 "4f8bf0ad43fef77e573d152b59f55a1f81eb84c22d6545911757e6108f8de21c"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60be2e68ac79687e237a5c5632996fa67950e0f08484dbcc755f114f46af984f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64766f0429546f2e7b9ab1376516445782d6cfc3048ddf607d1f0a53eec92c8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a669a2e7705dd8c818c017584fd1ee99bb59d3f6de27c9c6d327fc2a593bfd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "38862662ec4c5145dcb083010065ce2c17be11b7cbc1dfa610ae4a8e49f0c109"
    sha256 cellar: :any_skip_relocation, ventura:        "83e2c545493b026a15942564dec3534a219cb19a106c18d20f80f5af97eb23b8"
    sha256 cellar: :any_skip_relocation, monterey:       "2d331d1cae791bc5f4a02b3f1b6a931fd2947fd941c468392de820e07e9a71f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "340bfeb88e716aa0abf8e16819495eeb57147d7ef87f06f998afaeef091cb329"
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
