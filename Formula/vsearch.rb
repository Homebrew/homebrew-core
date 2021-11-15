class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.18.0.tar.gz"
  sha256 "faa585ec2767e15a8ad3c2b78921b789a3b174fe3b0eecb3397b1c795808e982"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66083739731ce00fb146b06efb1eb8f7007dbf3e24c8ddd13a853ae0f9c42dd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc8381c80eec137ec9b59ff781c603d0f70ba2fa97a1cce6f51a0e452e7bdc8f"
    sha256 cellar: :any_skip_relocation, monterey:       "fd4900ba58550a865f7a5929ebd39c073a7b7e51aa2a3fa23e98f5d0a3fcc1fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3865c00e1968566ee8b48f860d3412cb3a9137fcab1a970cc3e519a206f63bf9"
    sha256 cellar: :any_skip_relocation, catalina:       "3003f6c4460a07260687b855ceb6f048a873afb0ccb9cdee1c5fcbc5d5b82bd5"
    sha256 cellar: :any_skip_relocation, mojave:         "622bf6c177ed7493cedb01fd8fb65868405500a20c9772ea957ca0bf59782986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180e70bfad482076a2d8f5bb78116421ce6b50cac6d161c4ede84cf447f89bd6"
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
