class TtyShare < Formula
  desc "Terminal sharing over the Internet"
  homepage "https://tty-share.com/"
  url "https://github.com/elisescu/tty-share/archive/v0.6.2.tar.gz"
  sha256 "4ea8cdc96fa889da414885e8cdbd8fca71569a9146ca4d3caa7cf2411ac141aa"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "adfa3de302df681f3e236d28f69dcb7cd63143582d26b698a034adc5337fe18a" => :catalina
    sha256 "b9b97a2733c85508451799419dfbc36326c8d9bfe30c26800bc22ddf2bd7b30f" => :mojave
    sha256 "6820c38434e99f26e0cc247ae89831376c914a6eb1ee0d4b20056a2ca2e7c0e3" => :high_sierra
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
