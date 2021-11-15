class TtyShare < Formula
  desc "Terminal sharing over the Internet"
  homepage "https://tty-share.com/"
  url "https://github.com/elisescu/tty-share/archive/v2.2.0.tar.gz"
  sha256 "a72cf839c10a00e65292e2de83e69cc1507b95850d949c9bd776566eae1a4f51"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "388de900c99e13aad0bf35cc202a2cb23dabfc240417bda1c2dd481240c7ae4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4207e631fd61f1e5ea1a7659d09b606cf10b5012a9b52153a956af15f5a7e160"
    sha256 cellar: :any_skip_relocation, monterey:       "4261e0442e86cf508ffe28aa34fcfb7ebb2c0f9c92f780bcbae6a39a0850771c"
    sha256 cellar: :any_skip_relocation, big_sur:        "004c70273ec6b94d912745c657639878149b86cdf1f1296d9d5498460f8b01b4"
    sha256 cellar: :any_skip_relocation, catalina:       "e02d15913aa63a1cbff110af076743dacc3c4d56cf828a0b22cf94d4e025b6e8"
    sha256 cellar: :any_skip_relocation, mojave:         "1fe5cd2eb19d7a0b0ee61a9b0dbddc13805055752827de2af6221e53d42f1b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2ceed45ef206a801e28d80ddb26c0cfd4767aa87cf07252ede2691a3eeef24b"
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
