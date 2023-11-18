class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "d88249bd3b630c908ebd308abaa9cd7acb7a781c12bab877d3daaab56f43c443"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6508944a8b1e559aca1bf8517a5c5d6a0e70c8a105b6cfd4d6aab9dd191dbc85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28110264d2e417c9357ad28f42b99a680cec251bf982b3296c65b28c8df8de9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "975d55610d697ae325859b0bc551a2ceab27e6ce6748deb2970069ff9650f2b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "16d2409e2fd7891902d686dc8dd1fda848f2bf8b06cc1c29112450f17afa819f"
    sha256 cellar: :any_skip_relocation, ventura:        "755c3e17cce4f83a7ba6210d25545ecd46c1be78dc6cd503cf1bee72ad03790b"
    sha256 cellar: :any_skip_relocation, monterey:       "b7a09773db836324a2827dfee6dbbca9fc4883236afeaea3b7b8a3b3d2e4de6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc5e598510a4f32a24c18b32825d26d10351fd9f5e0933ad52d49ebdd97a1ba3"
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
