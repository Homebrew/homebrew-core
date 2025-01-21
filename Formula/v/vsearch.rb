class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.29.2.tar.gz"
  sha256 "7baf08c08f7c3e7488f3fe8d54909d5c1bf6ecbf590105323fb5444fe40ffeec"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06c5f002c59a7902b3b8765d4acaed648a44f5e18ba23849b05005d958b2c5dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67f549cc778a59e8f722d9c132b685d24706ef61428b5807f6fb3b90bf3314db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b23b0b193c605ab4ee8e5c17b551d8fc4ba058400e3e4276edc5bbd45777653"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7ac9cc9a8b37e6f8e80f968c48fd874bc32bcf18c2041dc6c787ba6ff37cd15"
    sha256 cellar: :any_skip_relocation, ventura:       "0224d8751a1cf86001f923452515a7ca3e7a796eef60fe9f547eabc5de99e959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93f9c7d35adeb548a4d5a7764cff584784dcd1b408fbbed34e26f069adc28295"
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
