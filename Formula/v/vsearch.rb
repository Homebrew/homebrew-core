class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.29.4.tar.gz"
  sha256 "ee55e764b01f538c4f3d3cf23b4550fe14d7a5922a8969ba14904dbb66064985"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3b3af525a5a7e0adae99c51c34a8395b925dfa90b410e915cd8ea513185b502"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdfd962c92074b10b81eb597fa68b7dbbe9df8395ea4b51a1cdcb64f2b69bdee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbb4dac41a4c34cde74c09ba70b3892503e3a0825a7134db1237a7c015e7f8f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "63a720bb512f0dc99414f2f42336a701a499a7871deb67ea76e41c7cffaff518"
    sha256 cellar: :any_skip_relocation, ventura:       "8c958694f1ca92f3fba1ccde7469e577aaa3cde75fa8d512e97dc616aec8393a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566d2666a7e58382125f5a8ab10f39a63aaef9ac8aa2304a2d78512fe13a11e4"
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
