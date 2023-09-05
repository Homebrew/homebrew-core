class Ssocr < Formula
  desc "Seven Segment Optical Character Recognition"
  homepage "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/"
  url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/ssocr-2.23.1.tar.bz2"
  sha256 "a6256abfc35fcbf6bc774aec281e176e9f7cabdf65ea2c1890720460eb417f95"
  license "GPL-3.0-or-later"
  head "https://github.com/auerswal/ssocr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9b68ac4bc049a9b267ed55f4c8c24849b323d8ced82d4357ae7186c1662adfad"
    sha256 cellar: :any,                 arm64_monterey: "6adb84dc391e2698fd8524874a0d4fedc7a0f1c0813b5689675ac85f6d19223a"
    sha256 cellar: :any,                 arm64_big_sur:  "db20f9830db2694bd1d00229c747db3783a63a1d982cb0c31390e3d9823b31a5"
    sha256 cellar: :any,                 ventura:        "10d8589622bc91e3894c78424cc7ab58c61d3ef6148a04eeed6671ee1b30c718"
    sha256 cellar: :any,                 monterey:       "92b1d79b2f4a21114fa1bc02906ef2e70152efd014e5825860887f0a93e817da"
    sha256 cellar: :any,                 big_sur:        "4183491c53880ce620df9bfeffa8502260b52bc87aff91d967d6a99e8064eddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1f9600c3c572c6b1e9c162ae027a7c17fdd8bbc8ee531f43c80a8c070feb14f"
  end

  depends_on "pkg-config" => :build
  depends_on "imlib2"

  resource "homebrew-test-image" do
    url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/six_digits.png"
    sha256 "72b416cca7e98f97be56221e7d1a1129fc08d8ab15ec95884a5db6f00b2184f5"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    resource("homebrew-test-image").stage testpath
    assert_equal "431432", shell_output("#{bin}/ssocr -T #{testpath}/six_digits.png").chomp
  end
end
