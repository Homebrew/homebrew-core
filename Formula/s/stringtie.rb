class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://github.com/gpertea/stringtie"
  url "https://github.com/gpertea/stringtie/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "aa831451ae08f1ea524db2709d135208695bf66fc2dbcdfb3d1d8461430e2ba9"
  license "MIT"
  head "https://github.com/gpertea/stringtie.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b8635ef5a2c5bb7d9badbab1fc0cebd6251eb37b2e86b7e3a49398946c77db10"
    sha256 cellar: :any,                 arm64_sonoma:  "e0cfafab884859f6f119ad427f41383c5db78602e17d0125e83855f8574388ad"
    sha256 cellar: :any,                 arm64_ventura: "fda12598aa1f3d83e317ae9c6b60a1a957cb72ea11ade9587863f255b19a8a3e"
    sha256 cellar: :any,                 sonoma:        "ca08236c2b9faa6036eecd48f829b5fd9d4939c1ba7f3975afef37d6d27e15f8"
    sha256 cellar: :any,                 ventura:       "9f34f83c30482fdf8ad0516a706b32b6bd570808f72c887ba5a915bcbe5f1340"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22b1a592ec90dce554d69752e3f8a0425a1e34ac2d92c29ba5462e159b95389e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dbebfd9c277e5e08b6e4e39842d672bf760fc0bea23fd9919668f794ef7e120"
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
