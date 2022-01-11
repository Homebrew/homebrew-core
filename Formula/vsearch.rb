class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.20.1.tar.gz"
  sha256 "d6ce261a7488c3b90b399238647a833500762ffe76e5428b547fc00a4588e0c3"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01ab9535766d694628de1bf150c114b4334b2066a65c58428e600726d528d85d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bb0dc6d093942ec04803810acddea55f34db5a46ebb7d47e19c8276c61a633a"
    sha256 cellar: :any_skip_relocation, monterey:       "67e753835a4eec6af2c192f20627c4e6d9ed0ce5439ed10c04f3e40d06508ee2"
    sha256 cellar: :any_skip_relocation, big_sur:        "40498cd86223b4e7291b11760a70c340252222319e3acb37746bc3c50de40d3d"
    sha256 cellar: :any_skip_relocation, catalina:       "422b67ce914693d35d296cf113da29a3e94e32ed7cfebc524faf8f2f5992c135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94914f2f2e82c315471aebac48b17da3b09242c742608febafaf92dfaeb69302"
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
