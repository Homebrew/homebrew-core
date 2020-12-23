class TtyShare < Formula
  desc "Terminal sharing over the Internet"
  homepage "https://tty-share.com/"
  url "https://github.com/elisescu/tty-share/archive/v2.2.0.tar.gz"
  sha256 "a72cf839c10a00e65292e2de83e69cc1507b95850d949c9bd776566eae1a4f51"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "77e717111ae6438a0fe5f114160e783693d5585829f8d00f382ad6b686e0b76d" => :big_sur
    sha256 "1f6e41a6aac4b7086f97febb4455b22441a6b9d85c6a9f03582353522155fbe9" => :catalina
    sha256 "faf04e53800eff483fd8d42b4f96b027d4142c089a7c8ce3dcde3083ecf12cb1" => :mojave
    sha256 "3c6e8bfc66a1801d3d8e7bb9e6d49fe594518c1389352b96f5677d4f0b6b326d" => :high_sierra
  end

  depends_on "go" => :build

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
