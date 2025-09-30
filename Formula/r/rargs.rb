class Rargs < Formula
  desc "Util like xargs + awk with pattern matching support"
  homepage "https://github.com/lotabout/rargs"
  url "https://github.com/lotabout/rargs/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "22d9aa4368a0f9d1fd82391439d3aabf4ddfb24ad674a680d6407c9e22969da3"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c1b481bcf7de6ad4a0abe5f77d33d8d2ab0f3bd6a6c36de248cf4fda715d89bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "07e463046394e64c0366a57c336e0a1e5cb5524f18f278e697d921ae923695c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c1b5594ef8bdb6f4bf04393a93e8081804b8918b79d8218bddcdb4b3b4b38e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db39ea8042e8c099c423325bf28e62fddcd985312dc39f2f9f7f4cee307b23f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63a38fdbffaba3ef942b5f7d29c093cf995f4ea1c3bef35f5194ad0a32b9d306"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4513c4e3dd9b6623322227d52001579b10bfb651a645ce143bd3927903d94e1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "325fe5d7ae7f301efe4d61142813d4659c982e5b70a90810b475d787118bbd16"
    sha256 cellar: :any_skip_relocation, ventura:        "a1030b51564a181c68ce37cc615ae774b53f72e24c9f0949a0fd5024f21996cc"
    sha256 cellar: :any_skip_relocation, monterey:       "ec12b996841e633e647a60d753e7a52b6d654f4d13755fd0ab509d7b75666c2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b385f4ac72270f54bf30989cbe1a12dc5a2ad4c78f67445f386b774b30456c9"
    sha256 cellar: :any_skip_relocation, catalina:       "32591f33510d8ead309401f8da9c91690830919c717d84b913a7ec7dbd764624"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "aa2cf424c90cd39a337bff0a8694b10b91b432b2311aa2710cc9bbba62aec33e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5986e0f6b1f35cf2cb8b2113965c30895942c065dfe24d61a17c5497de6f9f02"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "abc", pipe_output("#{bin}/rargs -d, echo {1}", "abc,def").chomp
  end
end
