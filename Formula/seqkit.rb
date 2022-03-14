class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/v2.2.0.tar.gz"
  sha256 "6e7e292532d78d54ac7aecb934f992c85d04b2dcb2d7a1141808bada0f5b13ba"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c89a2abce52fe88ae43fdd5a6bb7029c499650fed71a88a8423dbb401351734"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a18b67f654caf6f9177e004e0b22db570bc4e157ba8feb0d94c287df2875268"
    sha256 cellar: :any_skip_relocation, monterey:       "44df9a540e423d15437fe39c3b65377a6ed3961b94678ba09bbe5ac6ba7a180a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb8bf5408c4c2457061b08c3156c78d0327966b33f746525e65636b81fbd8d7b"
    sha256 cellar: :any_skip_relocation, catalina:       "c36a35635fef319c1f63f792764a2bcecce3d2a00f1d66ba2bcb1b97c2f71c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "419e6f1a7d61d28140f84fe99fa2e033ac182a5b0f658ecb7ea953f2d34129e0"
  end

  depends_on "go" => :build

  resource "testdata" do
    url "https://raw.githubusercontent.com/shenwei356/seqkit/e37d70a7e0ca0e53d6dbd576bd70decac32aba64/tests/seqs4amplicon.fa"
    sha256 "b0f09da63e3c677cc698d5cdff60e2d246368263c22385937169a9a4c321178a"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./seqkit"
  end

  test do
    resource("testdata").stage do
      assert_equal ">seq1\nCCCACTGAAA",
      shell_output("#{bin}/seqkit amplicon --quiet -F CCC -R TTT seqs4amplicon.fa").strip
    end
  end
end
