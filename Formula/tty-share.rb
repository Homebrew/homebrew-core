class TtyShare < Formula
  desc "Terminal sharing over the Internet"
  homepage "https://tty-share.com/"
  url "https://github.com/elisescu/tty-share/archive/v2.2.1.tar.gz"
  sha256 "c42119dff70eb2ec861463ed7d1d60de44c0c93d83c10a88873c11393decfbc2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8da0dd00a1b06776e05e9092a215f77bf8d6b1cb071d75a0a548900c9f5f18ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71120808d4909fdfdea8596392bf7bb50936ac1c0b329b13c60bdd061902d9a3"
    sha256 cellar: :any_skip_relocation, monterey:       "4510766c5cc29ed7b67080cee39e59710445d6fd5e904c706a3a681d9720386d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e104200b09c5acd6bba873cd07e41b322ca7fed316fb3c74cb5eabbfe773ba5d"
    sha256 cellar: :any_skip_relocation, catalina:       "1ab51ccd10571a99fadd713b01def94aa1afc9e433d372b78612859b863995d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fb65f718d04bf4102ae9453766f769f4770612c367b99d55b6b610dfaf075fc"
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
