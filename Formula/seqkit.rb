class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/v2.3.1.tar.gz"
  sha256 "814930772645a1c5f491a0a0f0498d967b6caa512f137e10bc0a1925f28f863b"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f57cbd62bbef0a0192b22fe821388169e4d66ab926a586241e2f3cb8913e117d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d8852c1400079f7869a90e65a96afd846658febb841392174400a3761f9c6d7"
    sha256 cellar: :any_skip_relocation, monterey:       "f448b6b365d9819acc7f90d8c5e5ae3663279d03669600a6dec1203820746d4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "55611359dea6f44503232815fcad360246610c038e255f7b6113030173db9067"
    sha256 cellar: :any_skip_relocation, catalina:       "a0117784a961caeb392ad6ea3b3cbeca41f8b358f499e250f3ef35c3bc0bc494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5913e6bf676b8c66bfc148eccb37cc227c07c6b7b6b592f5171826bbfb5b2cfb"
  end

  depends_on "go" => :build

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/shenwei356/seqkit/e37d70a7e0ca0e53d6dbd576bd70decac32aba64/tests/seqs4amplicon.fa"
    sha256 "b0f09da63e3c677cc698d5cdff60e2d246368263c22385937169a9a4c321178a"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./seqkit"
  end

  test do
    resource("homebrew-testdata").stage do
      assert_equal ">seq1\nCCCACTGAAA",
      shell_output("#{bin}/seqkit amplicon --quiet -F CCC -R TTT seqs4amplicon.fa").strip
    end
  end
end
