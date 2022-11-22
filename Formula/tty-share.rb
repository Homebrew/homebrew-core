class TtyShare < Formula
  desc "Terminal sharing over the Internet"
  homepage "https://tty-share.com/"
  url "https://github.com/elisescu/tty-share/archive/v2.3.0.tar.gz"
  sha256 "e9c5c2132e04ef2a753fecc18b6166f78eec0979587fe180ba292bea9d98f104"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec5a76de8293add88e19ebbaabab162d5376f1195d2f59ae98e231b94963ac90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae91bac5a098c2c243dc09bb525c77d2cd4267fc95ee78185b72e4fd4b2784c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e112fbe0c7f60d68932d342dab6149c3f2cc43c95d38394665b796e7d637b768"
    sha256 cellar: :any_skip_relocation, ventura:        "7fa9e01789823ddc5f61bc2219f800072a76ad436abd9960ef5528610da7afa8"
    sha256 cellar: :any_skip_relocation, monterey:       "98308b7a54e8584fa17e27d360578faace5135d2595acd9b63bd61ae2b691e00"
    sha256 cellar: :any_skip_relocation, big_sur:        "5afea58ba59412b148dedd82a56e99a662f377d4301fac5a54a002dea3dae175"
    sha256 cellar: :any_skip_relocation, catalina:       "d00663b2cb3667fd92774bf185bb794271338dd7c2a94c8fecf92571072c63ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f842dadd8abe2579b51fe7bb2a459b2aec305b3fa58c31bfc20e1bb4fd721430"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=vendor", "-ldflags", ldflags, "-o", bin/"tty-share", "."
  end

  test do
    # Running `echo 1 | tty-share` ensures that the tty-share command doesn't have a tty at stdin,
    # no matter the environment where the test runs in.
    output_when_notty = `echo 1 | #{bin}/tty-share`
    assert_equal output_when_notty, "Input not a tty\n"
  end
end
