class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "2c5bd0d9b3c2ec8eecd1af06ae11611138d87fdfecfa423ae791d52dccd27e63"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fe2e3d48358f193a0277f08c8c571315149b20569f7fcb89491834349fc091b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a050937a85f886531f4b5c1434d26aada1e18a90ac79d74709468b2fba6732f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c400df11b6e89dee8e34547409b2cc4daf45bcdc9ffcdd92b9b096837d8a4882"
    sha256 cellar: :any_skip_relocation, sonoma:        "126026ac43c82420f50fdcc93ecc395df3bceb16735aba08e8597def7f9d9e61"
    sha256 cellar: :any_skip_relocation, ventura:       "991666da3476f414c1affd38b277bfc3a40cc51a822ac70b678f6aee558b88f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84cb30af9705f54993c9939f1a6696a35e264a0f17a678f5a7255eaeb2b46d99"
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
