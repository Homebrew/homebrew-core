class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.17.0.tar.gz"
  sha256 "8c783c27dbdd416f48bd1b7317c1669468f3e7ebe7717b84de6794a2c1e998b9"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "76bf10a8064fec4fe1450b24ce8417846c1a20781e105c28ef65e58bd76d4b45"
    sha256 cellar: :any_skip_relocation, big_sur:       "4b0b6a188488070c37c50333979320de9ed21f5d647309c925be3bd5164c10cc"
    sha256 cellar: :any_skip_relocation, catalina:      "dff46af5fcc8431b17ea7ea6d9eec99bd1a27b719485be98e1b18e3000b3509e"
    sha256 cellar: :any_skip_relocation, mojave:        "73bbb4032ee983c57dd4632b3af03e005f04322b6e69cb6ada96d923d0135556"
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
