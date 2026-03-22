class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "https://github.com/gpertea/stringtie"
  url "https://github.com/gpertea/stringtie/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "e96b43d1482b5d7fafa8513e8490e55accad14a82e7d9c40b8693748f6e4bb9e"
  license "MIT"
  head "https://github.com/gpertea/stringtie.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a04a687393f0a23bcac7e9f8e0a45542ae2e95eaf5d9c91ff3ebda1122ad380"
    sha256 cellar: :any,                 arm64_sequoia: "3eea05d76ae06b8873c6152061cd93b36bf4fd90274cb81e74d82cb2fb8716eb"
    sha256 cellar: :any,                 arm64_sonoma:  "2e2833f5dc86edfc9bd1897ad07673c0a03e18c2233e32bc884ee5b1b37f172e"
    sha256 cellar: :any,                 sonoma:        "12b536ae977cdbcb08345151f66222a3b494aa99f43d2e6b4ef5482e393216d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38a474188009a577779e293f2286fc943c2dc9430b4a5e38b21f10cedf3d4ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26fa7ac3ea5c68176b84c083da76ab9865b61603af6c00ac5efdb9e8581e9540"
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
