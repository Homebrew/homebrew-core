class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "33513d1e4419c2a6c95bb9b01fac883a83fe032b248ccd4b1de7f909dee69db3"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e38f81ca4cd1a65cf624711fdbc5e77b2e18f3204530450dd1ffbd796dad93a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80f8667a9919e51647b5c02b6b037e7600b59b5497c9f461ecb452913228d4c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9136d710f6026ab89f701bd9eec3e53aa726eeca74481696ac651442e61cccb"
    sha256 cellar: :any_skip_relocation, sonoma:         "28767a20cce6a10512e1193f900a0bbf34845a9b3c97944923bcfe6a01927066"
    sha256 cellar: :any_skip_relocation, ventura:        "9226d1f08f42a29bf255e81a051d8252244ec23d73bf3d1b5e520b094ced2fdc"
    sha256 cellar: :any_skip_relocation, monterey:       "2943c75dfb50071cd65f9d46d2be3922e4f634f0cea936cd5ee5788d312a3eec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fb7e9c3735b32ec67f0150f24973bf0d80126000721bbc3dc25a5e37e9d0813"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./seqkit"
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/shenwei356/seqkit/e37d70a7e0ca0e53d6dbd576bd70decac32aba64/tests/seqs4amplicon.fa"
      sha256 "b0f09da63e3c677cc698d5cdff60e2d246368263c22385937169a9a4c321178a"
    end

    resource("homebrew-testdata").stage do
      assert_equal ">seq1\nCCCACTGAAA",
      shell_output("#{bin}/seqkit amplicon --quiet -F CCC -R TTT seqs4amplicon.fa").strip
    end
  end
end
