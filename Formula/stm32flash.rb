class Stm32flash < Formula
  desc "Open source flash program for STM32 using the ST serial bootloader"
  homepage "https://sourceforge.net/projects/stm32flash/"
  url "https://downloads.sourceforge.net/project/stm32flash/stm32flash-0.7.tar.gz"
  sha256 "c4c9cd8bec79da63b111d15713ef5cc2cd947deca411d35d6e3065e227dc414a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/stm32flash[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38b8fa0ed69728d5241842266710e1a788e50bd1ceab7fa2a01606dbb62cf887"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8d0be7957abf2048e99a1fea198a207be5edbd7ccdb402b8bfe650575ac64ef"
    sha256 cellar: :any_skip_relocation, monterey:       "eb2bcf9748b22a6d1809d675ad765345f0f539d0dbf49449d0977618e4e7f019"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3a9d072fce40d5fd3af1f86019966abf4d4a711b26ad8539ec382aa6dfc5848"
    sha256 cellar: :any_skip_relocation, catalina:       "8e76969a80aef9a483e6ad09064f1b7d08e2d5e02829c12d2dc0e9a31256f9a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b63e10544099db4a148fefe54fe036746f96ab2e1d637e73702ae458cb442f93"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/stm32flash -k /dev/tty.XYZ 2>&1", 1)
    assert_match "Failed to open port: /dev/tty.XYZ", output
  end
end
