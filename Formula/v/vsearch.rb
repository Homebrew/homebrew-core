class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "6d11ce960206ab64cf6d7907e539348d192a5b3f32f82d37c9bfbc4d789b576c"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5f7cc238606626fa0e7ef7934d1be830a1f6d3414948d96c64657a7c0e7261d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95bf8675d1df686a387c61e8abe592dd295f6f20a6d8bde1dd5820cdeb3df895"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a10dde53f6f72b7c42c64149cef00a946903a6ca381666d7a4185de57816ba1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "76c2bfbdcee1d144d998f55efb5b2f065307fe95c05d1ca9f4d8f66c65b4d035"
    sha256 cellar: :any_skip_relocation, ventura:       "1d00ca3077cc1516feb5b8b6b9d7aa1895c7d739c937763961c9f6d50921d164"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8168ba9f58fa34485373f017f8f6b65ec5a8c1643828080cb8a0db8c1173fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ede91c3962acd2f7600a7d8b2c0bb33506507ecfa1ff07d272a06bab3816e6"
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
    assert_path_exists testpath/"output.txt"
  end
end
