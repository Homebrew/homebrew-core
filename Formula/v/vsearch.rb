class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.29.3.tar.gz"
  sha256 "125ce3079a9a1082544ba60d66ebcd0712c9acbd3c794ef6b07892143aa5cc0c"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dae6413f79188ab798ac5a36bb2076e81495b824c7b7ee41e397a312c619d22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2750f607aab9f93421c2146f65daa78dbc0d707c1c8680b0ddce751cfd3fd31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8485b7eb3086da1da498a94be4c4495dac8c66909afb51f329ef58b5fba64e73"
    sha256 cellar: :any_skip_relocation, sonoma:        "d95dc3970b63c6cf6803d49a960ee6e6e35811e1a58d873f3940a77d2bea1767"
    sha256 cellar: :any_skip_relocation, ventura:       "96231c2e3be04866990837a34642c64bb3ed1c0b45907acec61cd025c3ab1c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a6ad50c2235aca96b07a733886836e977d9be58371158a53ed1fb455251cb8e"
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
