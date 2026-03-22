class Wumpus < Formula
  desc "Exact clone of the ancient BASIC Hunt the Wumpus game"
  homepage "http://www.catb.org/~esr/wumpus/"
  url "https://gitlab.com/esr/wumpus/-/archive/1.11/wumpus-1.11.tar.bz2"
  sha256 "6b60884df963d785759ecde67382cacae2989f666be7b6269af511a51fde5458"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/wumpus.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca80b761f2f03f3dc6edf792c87aec2c1cc25a99a4c27706bdf8720047cbe141"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "735a371a20ddb23cea467834a5244743aa2d9924721eea96b68865b325ac2099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "778ce27ccdb418011b0a7514e4427f96d19d3d203554bfacc058fdc63b2de4d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "37e7079f488ea57258b203ed2a4ce83a23c1919dc86bac68a97c92114f11ebcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb85d9dd188dfc4842b6816e0696322c99a00e7b2722faeca5f891112dec9437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21f6da1c1f436b41491e88e68bd184dad53852f0aa1dd95c6d34f433c5109471"
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
