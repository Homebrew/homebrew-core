class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.18.0.tar.gz"
  sha256 "faa585ec2767e15a8ad3c2b78921b789a3b174fe3b0eecb3397b1c795808e982"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f73218e3ea4deeb31071161322f5d463c14e037d43cffad0cd3421cfa7cff9e1"
    sha256 cellar: :any_skip_relocation, big_sur:       "d05f94ce99512a34a86b4175b475690c602717b9db66a397f7590f0fb7dddd48"
    sha256 cellar: :any_skip_relocation, catalina:      "f49645745a5e19d2769bf85107704efa369378998b2032020b8fe53c674d1742"
    sha256 cellar: :any_skip_relocation, mojave:        "a6b4c046412b638685e4a4e31fc66c1945f6c91fac9f657130a75ed76e3fbf4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc66ec8e17f721818e3b16f05e66c545c1167a78c19e423f93e6ae73aa4efd67"
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
