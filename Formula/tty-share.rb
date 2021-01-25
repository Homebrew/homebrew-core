class TtyShare < Formula
  desc "Terminal sharing over the Internet"
  homepage "https://tty-share.com/"
  url "https://github.com/elisescu/tty-share/archive/v2.2.0.tar.gz"
  sha256 "a72cf839c10a00e65292e2de83e69cc1507b95850d949c9bd776566eae1a4f51"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "004c70273ec6b94d912745c657639878149b86cdf1f1296d9d5498460f8b01b4" => :big_sur
    sha256 "4207e631fd61f1e5ea1a7659d09b606cf10b5012a9b52153a956af15f5a7e160" => :arm64_big_sur
    sha256 "e02d15913aa63a1cbff110af076743dacc3c4d56cf828a0b22cf94d4e025b6e8" => :catalina
    sha256 "1fe5cd2eb19d7a0b0ee61a9b0dbddc13805055752827de2af6221e53d42f1b9f" => :mojave
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
