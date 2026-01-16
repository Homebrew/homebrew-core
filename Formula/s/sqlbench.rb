class Sqlbench < Formula
  desc "Measures and compares the execution time of one or more SQL queries"
  homepage "https://github.com/felixge/sqlbench"
  url "https://github.com/felixge/sqlbench/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "deaf4c299891ce75abff00429343eded76e8ddc8295d488938aa9ee418a7c9b3"
  license "MIT"
  head "https://github.com/felixge/sqlbench.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "8c496486c81f8ef1e302ef65bdb290f2d6374e1b1840a7e970991a2ea76bd219"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bb5fc33b6e66c2132a7369001b56bced611e9f7b7f7d2488cf11c57f7f7c77ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ede04ad826d75e794b7fe73102638e05fa6d800fd9621d9060817afe5b1c398f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0598ce5d9b3c1aed37b1690a3e8357300b3ef8906ea2275fe1ee997375c09e98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14d3a0b3a26e3291ae1039e67c72970b4a1b0388387b919f2c71e01e24e6a429"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8373986acd8ee9e32df964c5bff6b365f29afa06fa256789017112d9b07ffcf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8238453f1e6614c8f14910cfcc53d465cc15cce3d4c8b11b6042be4b36ad319"
    sha256 cellar: :any_skip_relocation, ventura:        "fafa90b195b10fa34a841acec103788f7e83277ca5b58c8a5763868857409dd1"
    sha256 cellar: :any_skip_relocation, monterey:       "a59e25067b830b0062a0d3c7fa98da5c31ef16c0763303f5acf16238aead26a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a74a774e1c5c5512b9230713af78f3694d38f237241817740c8f244febe8e09"
    sha256 cellar: :any_skip_relocation, catalina:       "a138dbb8bf3fa6293e51b49e91e35078c8c2d7dc399c70a61705f047b519a8f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8865da934790a89133f570b9e8501d9648fbaeb33f49ec8a21867625f5b8da41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0e961ada32e3e6588b0a328d3030f39e7bcc1457b63573608347e28cd5960cf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    assert_match "failed to connect to",
      shell_output("#{bin}/sqlbench #{testpath}/examples/sum/*.sql 2>&1", 1)
  end
end
