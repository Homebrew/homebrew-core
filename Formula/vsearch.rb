class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.15.2.tar.gz"
  sha256 "ce821f5f870c00938ddc0938ba5a13f17e697a9ddd1d53cfbebd276ae4c640c8"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4d94291e05b0e22797c10612563c129aa0095843459eeb98d2ff96292dcd9e28"
    sha256 cellar: :any_skip_relocation, big_sur:       "6801f717e69fb4c30da5fa87c54bd2e19e05af88f7b08b8efbf0df0444a6ef15"
    sha256 cellar: :any_skip_relocation, catalina:      "907ea4fbfaae550577d4f9569e7602bc55668fc8a0f0594907f69ab2ce80b25f"
    sha256 cellar: :any_skip_relocation, mojave:        "f0a8d4c30ce9921d29d574266c83bfd47ec4a0d8e7428790ca82a07b410f0deb"
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
