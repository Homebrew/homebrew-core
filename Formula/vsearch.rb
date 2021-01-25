class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.15.1.tar.gz"
  sha256 "b10e93f1bdbb79dc689cb6e0c981d71f2e20eb8c4817392aa7f6b30da54e583e"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    cellar :any_skip_relocation
    sha256 "f93eaf8d2c94693f7eaf185790604b49e2dae03a7a7569c031e5a73a2f1fdd15" => :big_sur
    sha256 "e93c5e950ad68cbfe3fa1568fa8975b294e0dd7d4cca86484433fa3a9614321b" => :arm64_big_sur
    sha256 "25c75ec8b1a1dc243b11145ba0cddcfb74d910aa682a20b0faa7d297f12de945" => :catalina
    sha256 "54adb18eb8744a4c6cd3c827c5088962e6587e4bc2becc1c296ce52304d62be2" => :mojave
    sha256 "c308c67a02b669b546cb179df8d3ec7b90089ccfc40fb4bdc11ea7e91994b55f" => :high_sierra
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
