class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.20.1.tar.gz"
  sha256 "d6ce261a7488c3b90b399238647a833500762ffe76e5428b547fc00a4588e0c3"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3607069043fa22ba0875cb6a80471e0904e60501b2483416fffc22dfcde1f511"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42ac81c7e8ac41fbc823398126103ed959d6317ce16e4b37ce59607abf5c9d71"
    sha256 cellar: :any_skip_relocation, monterey:       "5f79a0bc6c49329aa8e274b6b848494bb27c790b4ee90c5869ca5cefc00c5b00"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc4988534e95a255a811b3dcd7af20fbf0e03cfad5b421a19f03d8d73b1897c8"
    sha256 cellar: :any_skip_relocation, catalina:       "4acb0a8d03376cab877fb774b98f605f4f3fb590d1c142b9be21ef97e78e39e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdc98a947220b6c6036228430fa4a897143a926f0f7b2e666f023557ea15b867"
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
