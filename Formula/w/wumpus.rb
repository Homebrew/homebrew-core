class Wumpus < Formula
  desc "Exact clone of the ancient BASIC Hunt the Wumpus game"
  homepage "http://www.catb.org/~esr/wumpus/"
  url "https://gitlab.com/esr/wumpus/-/archive/1.12/wumpus-1.12.tar.bz2"
  sha256 "0963a7690e0e739f757d59dc1df07083fa96d3a27d800d571a1977a6d0fa48ef"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/wumpus.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3ca0c0886c0dd3868abbfe1c24f7b83c6dec9dc0e9663ef929a509021942345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fbd39673cc697191825c2cc198468300c1d12fcbbbbbf7d9354b9aa4e9fcd45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9efb224977eb417f92b209544e3e2d6c0a84da9a0aee8f73b4578f5f30ba07e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "447dad64b5fb4879962d5e2d7092fc647e55e35aa368ed181f9d8a38883b50cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a13fbe27595a623425ab6efffcc1341d85597359c32f13695af61b5f81c6ebdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6189ea20b9332332f7c1b7e5615cd8dcd561ce9a096ed86e0ed08d2b07561dc6"
  end

  depends_on "asciidoctor" => :build

  def install
    system "make", "all", "wumpus.6", "CFLAGS=#{ENV.cflags}"
    # Not using `make install` due to issues with Makefile
    # https://gitlab.com/esr/wumpus/-/issues/3
    bin.install "wumpus", "superhack"
    man6.install "wumpus.6"
  end

  test do
    assert_match("HUNT THE WUMPUS",
                 pipe_output(bin/"wumpus", "^C"))
  end
end
