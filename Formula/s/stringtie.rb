class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://github.com/gpertea/stringtie"
  url "https://github.com/gpertea/stringtie/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "1e5cdc7a739d2cffa6dbbb4c28c1029476cc5002531a1438a1274ac381487a4f"
  license "MIT"
  head "https://github.com/gpertea/stringtie.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "780365bec7e6091368a852b69b9170aa8710ad5387a5caa520312899dc3e29d7"
    sha256 cellar: :any,                 arm64_sequoia: "764025772d0ac9adc2126e50397cbc8f425ac2f0ffc62ddf196ee6f478b07d57"
    sha256 cellar: :any,                 arm64_sonoma:  "b1185499c7e4d79e4fb71aab57c305804156a06abfeffdf77b45852f6b7959f4"
    sha256 cellar: :any,                 sonoma:        "d1dc3799f40d69897a68f37144235c10688bea264d54ae6c4ee9cff7cee1e554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d953ed47055c2826edde2e378b7a792b8976003fbeb8e325c4eee9d19e8b9a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87cb579b09f49065becc0a3ce2b19363b2c719bb22f82f97421b82b3a3275ad5"
  end

  depends_on "htslib"

  def install
    args = [
      "HTSLIB=#{Formula["htslib"].opt_lib}",
      "LIBS=-L#{Formula["htslib"].opt_lib} -lhts -lm",
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
