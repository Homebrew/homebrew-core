class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "fb6348fe38107cdcde6e3651913aa54eb8233fcd3379ab9e7fc936c090e05915"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d8b9ab0f3fde61175c373245f0e87d9ca5d996f7c89e23123604f5e12dc59a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eca6b41c114b6f5caa08784fdacbc5e5b5fc4b260d714a3500d3af913304882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "badaa33b7f2042eb49aec8e6555752dbc04d6b4cce4580410da57f5d173f094c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9593902fc009f2dc112f7f3233cbaa4ee7420aaa0b2826c011201748a6468dcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "331d36a94997b9dc1ad271f5457878bb198279c480e1817145ed52765413ddfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50091454f90a2d9abe9135c52f104b5b88effe51c34335ea7e4a0f7f1361cfd1"
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
