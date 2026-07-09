class TrimGalore < Formula
  desc "Wrapper around Cutadapt and FastQC for quality and adapter trimming"
  homepage "https://github.com/FelixKrueger/TrimGalore"
  url "https://github.com/FelixKrueger/TrimGalore/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "6dd4d99c10a2d1e740d8e49ee870b1f9a7ccb8ee94c0bc5183d2ae507492aab0"
  license "GPL-3.0-only"
  head "https://github.com/FelixKrueger/TrimGalore.git", branch: "master"

  depends_on "rust" => :build
  depends_on "cutadapt"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trim_galore --version")

    (testpath/"reads.fq").write "@r1\n#{"A" * 30}AGATCGGAAGAGC\n+\n#{"I" * 43}\n"
    system bin/"trim_galore", "--dont_gzip", testpath/"reads.fq"
    assert_path_exists testpath/"reads_trimmed.fq"
  end
end
