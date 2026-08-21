class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://github.com/gpertea/stringtie"
  url "https://github.com/gpertea/stringtie/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "cb473760912a7a23b09232171902b57a973ca791510c526a7a60f23616008ec8"
  license "MIT"
  revision 1
  head "https://github.com/gpertea/stringtie.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9a26d854ed3f0ae70cbbbbef204aa8aa69e55538ab25bd2142f2faee79839a43"
    sha256 cellar: :any, arm64_sequoia: "b88561bc6091fab88b8f410b0b5aa0492c6b99a10f8435470fb7521c523428b7"
    sha256 cellar: :any, arm64_sonoma:  "705c00cd726b9af2a9f0a3f95f65b889b49f84f85c75163da83557f7887c0c25"
    sha256 cellar: :any, sonoma:        "b6d5162f93fd9f12066a22ee38fe33e1d8f7ac65867dd51e9ef179d750572dae"
    sha256 cellar: :any, arm64_linux:   "355700943f868bd6662ce838e22e784dc8a4e2b7778481e3541d82499938a88b"
    sha256 cellar: :any, x86_64_linux:  "0462744257f8337aa6f3a61348286d4fdabfcb220cbdee729d9b18aa005890ce"
  end

  depends_on "htslib"

  def install
    args = [
      "HTSLIB=#{formula_opt_lib("htslib")}",
      "LIBS=-L#{formula_opt_lib("htslib")} -lhts -lm",
    ]
    system "make", "release", *args
    bin.install "stringtie"
  end

  test do
    resource "homebrew-test" do
      url "https://github.com/gpertea/stringtie/raw/test_data/tests.tar.gz"
      sha256 "815a31b2664166faa59cdd25f0dc2da3d3dcb13e69ee644abb972a93d374ac10"
    end

    resource("homebrew-test").stage testpath
    assert_match version.to_s, shell_output("#{bin}/stringtie --version")
    system bin/"stringtie", "-o", "short_reads.out.gtf", "short_reads.bam"
    assert_path_exists "short_reads.out.gtf"
  end
end
