class Trimmomatic < Formula
  desc "Flexible read trimming tool for Illumina NGS data"
  homepage "https://github.com/usadellab/Trimmomatic"
  url "https://github.com/usadellab/Trimmomatic/archive/refs/tags/v0.41.tar.gz"
  sha256 "ad4cd81f665a6b8b066fc9513cd4a13612fa98f06ada27988473248ee6110ad3"
  license "GPL-3.0-or-later"
  head "https://github.com/usadellab/Trimmomatic.git", branch: "main"

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "package", "-DskipTests"
    libexec.install "target/trimmomatic-#{version}.jar" => "trimmomatic.jar"
    libexec.install "adapters"
    bin.write_jar_script libexec/"trimmomatic.jar", "trimmomatic"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trimmomatic -version")

    (testpath/"test.fq").write <<~EOS
      @U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII0000000000
    EOS
    output = shell_output("#{bin}/trimmomatic SE -phred33 test.fq out.fq " \
                          "ILLUMINACLIP:#{libexec}/adapters/TruSeq3-SE.fa:2:30:10 " \
                          "LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 2>&1")
    assert_match "Completed successfully", output
    assert_path_exists testpath/"out.fq"
  end
end
