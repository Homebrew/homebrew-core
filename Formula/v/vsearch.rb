class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "18d6fc919adce684c01fe57797e2adbf5b4d4f6cf5ef169378ad473797be38ae"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47af4e3a3ea668c9e2e6ad5c67a3f6016f74b127a80ce7053276fc94a5dcbc54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c07a43e6aef6330d6d30bad37f4d7b9ff3a90affba39edfa7b300ecfddf1591"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "116aef340c26cb926ea3e2208396b6b8f825abcb58fe4d6a9163cf0736c286ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bc5d7eb24d16764bd87c7751583c417f2034a6d4070d9b5ababc88ae60f8a3e"
    sha256 cellar: :any_skip_relocation, ventura:        "9509304cfdcdd33419bde78ad4b11b03dcd2d241fe7c757d9eb5cb52a63cd75a"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b9401ed6f61e1738e6b659038647981e0957c1e4680728374b8f9bf2073873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1749e6e3e3935e3d5a346b64a105eb4df3fb62b558d217d024c3707b8f3194c"
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
