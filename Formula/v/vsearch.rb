class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.30.4.tar.gz"
  sha256 "8b26741fc71a01bb649576b0cd8650f8baae6d72e0e96fac29cd01d210fa75a7"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "539fbd49a21e13368243fbcdd1e64fae33c828d1de79e6e2ea1fef30fcdd28ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4e821598add3f29decde320e2ae62d878a124c66a9bb9a853d1354d6063838e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42282e0e131b3587f6c40e2cb7b2495c5771d85b82a3307ce18f80aab5a46350"
    sha256 cellar: :any_skip_relocation, sonoma:        "3443ada3ee79013abb6ce44dbda9e5f61f05e4dc06b268f8b3d8e6fed61ce2a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c6b5be25b7266edcda3ec361080bb234405f0a760f56f5fe874ebfff4569770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bbd6e819eb473c28c706996763dd8abdeafe707b7bf99838fee5e453f13ba77"
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
