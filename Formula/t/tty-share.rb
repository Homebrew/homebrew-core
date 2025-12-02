class TtyShare < Formula
  desc "Terminal sharing over the Internet"
  homepage "https://tty-share.com/"
  url "https://github.com/elisescu/tty-share/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "abc186307a95f55f1750592a38871d4839d2ff26365880110bdf107675ea264a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df6d54c41d4ea39472c924d0741c20d7bfcc0782a97886f64e01ab211c5ece41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec03c0cba5c97e463a37e817eb97638bdb3b9111821fd1c44760ef33e0d33ada"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec03c0cba5c97e463a37e817eb97638bdb3b9111821fd1c44760ef33e0d33ada"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec03c0cba5c97e463a37e817eb97638bdb3b9111821fd1c44760ef33e0d33ada"
    sha256 cellar: :any_skip_relocation, sonoma:        "d89b2fc16110d5ee948280744ed4a703d86242a31f96e00ca98f1b6dcb3b9adf"
    sha256 cellar: :any_skip_relocation, ventura:       "d89b2fc16110d5ee948280744ed4a703d86242a31f96e00ca98f1b6dcb3b9adf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfe97df24936c6e03ff13104c270616dde9944f4ab07456f844bab82f92776d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2a9c4c7c1155365d7eebcd4bfee4d22010b21584bc843f17d1b4c513182f01c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # Running `echo 1 | tty-share` ensures that the tty-share command doesn't have a tty at stdin,
    # no matter the environment where the test runs in.
    output_when_notty = `echo 1 | #{bin}/tty-share`
    assert_equal output_when_notty, "Input not a tty\n"
  end
end
