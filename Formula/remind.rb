class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.02.00.tar.gz"
  sha256 "a6476cf0dfe71bc4668e774669100c58d68b68dc6ccf08ca7ea9fa3345e72739"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "089fe61ccd62e4d21d8300aec7443d06216fd016433231626980bb15de2209af"
    sha256 arm64_big_sur:  "3b89b261ee81a7764cdb86ede8d57b2b926bb65d452a34a7c97f33bb11258154"
    sha256 monterey:       "5ce8edd534f5960ccedf415a3eee61acc820bc813fe4c8df85e8a5c16e2028a0"
    sha256 big_sur:        "2185586a6dd32c1e8ee7ef54d107494d7d518bdb968ea9459509104f19ee0c5e"
    sha256 catalina:       "7c371a4772b7fd6fed50d54ce4798338c110c58dbb735e96af1835637b5ba659"
    sha256 x86_64_linux:   "091561d4de3225c1f214fff2281e611771615ef16f252ab2dcc733ea635e950a"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end
