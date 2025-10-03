class Ttf2pt1 < Formula
  desc "True Type Font to Postscript Type 1 converter"
  homepage "https://ttf2pt1.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ttf2pt1/ttf2pt1/3.4.4/ttf2pt1-3.4.4.tgz"
  sha256 "ae926288be910073883b5c8a3b8fc168fde52b91199fdf13e92d72328945e1d0"
  # Uses a BSD license that removes a different clause from BSD-4-Clause than BSD-3-Clause,
  # i.e. it omits the non-endorsement clause (4) and retains the acknowledgement clause (3)
  license :cannot_represent

  livecheck do
    url :stable
    regex(%r{url=.*?/ttf2pt1[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0d173b72ff99b8f7d512c1017fa40e52a1b6f7e5432338f5846ce62511cb219e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b6ad2fb422b592e707adf8a5e622a1aba01994fdeee1979ce0810e1a7fea435d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35473cb3d10d199702745a66cbd1219309eb884b517d5a1f3356c2b83ec717dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6dae9b03e84c199e865c7b0852804a408627bcc5251dc219841371e391a8753"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "821e641a7addc5001641aac0fb7f610cc2ede29766dd09df88dea12968d3eda8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b3f1cd65430d9bf494da6fceebb293a0f21840191009525090258871eced58b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae066b9ac0a6bc08cbfc13d07433918ea6119e6c41f5f15b0dc07170650b2fff"
    sha256 cellar: :any_skip_relocation, ventura:        "cf3ba7fa8cbaf80acc4667dbc7abf8004d8d86892448b857573f6330bda988dc"
    sha256 cellar: :any_skip_relocation, monterey:       "94c056ea4644c7820eb48d3c85964b43c6e42f479efd374128f311f919a93f65"
    sha256 cellar: :any_skip_relocation, big_sur:        "736c22b9245fa658e10cbb775f943e93bbf42f90477999647461102e87832f29"
    sha256 cellar: :any_skip_relocation, catalina:       "29a39e797de6107bfe0878e68eb0eabd67d7cbb9b10e76055f1d9d3618a1a842"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e4c6c32597ec38d178f8c2fd2bd7fc0e38b8b916a15250b73bbcd42fa07eb734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa39b65205b22d6c02893d9b5c503d0309edeb8884e0e9336c9d725dc049a666"
  end

  def install
    # CFLAGS_SYS is used to fix compilation with newer Clang
    system "make", "all", "INSTDIR=#{prefix}", "CFLAGS_SYS=-Wno-implicit-function-declaration"
    bin.install "ttf2pt1"
    man1.install "ttf2pt1.1"
  end
end
