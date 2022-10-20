class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/v2.3.1.tar.gz"
  sha256 "814930772645a1c5f491a0a0f0498d967b6caa512f137e10bc0a1925f28f863b"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11969f64223bc8a71d041bf2934644d53df932a1d7e30dc86f4f93a5b6eb3eda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c95f03f99dd50792c7df76870c808d973549c642451d8ffa53af667e1c13b481"
    sha256 cellar: :any_skip_relocation, monterey:       "98a8f262be6da9b75e696a8eb078f3980765dd290692cc97f43ea55e5511a630"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6ecdb987395a135f714456e2ada365f83ae10c33a976da97f261289a2fa6c8f"
    sha256 cellar: :any_skip_relocation, catalina:       "4a37dab9864f1329fc6a00acd714ca75ce3fecc2d83132cf22b4434bd0dcf827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d90f15ba8fc7602ddf3b9498a3ddad7dd00b2f828730613a2bff6088cf57d9e2"
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
