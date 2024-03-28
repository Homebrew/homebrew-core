class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.03.04.tar.gz"
  sha256 "5e417fb22941c03950b7d4f6c2650c3e1ecc884f7207ebd7ad2426127044a42f"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "1cecf2834d174c2f59288cff1cacbf1dd51f01ae6f52397bf6e06944a1ef3b0a"
    sha256 arm64_ventura:  "0dc01fc202d30d697058664f098a138b3e3b9aebab8c6a8995e7e0e5a049c70a"
    sha256 arm64_monterey: "b05acc5b5afeb2ccd599c54f11747183af2b5bdf45cf09a57764b0caacfeb150"
    sha256 sonoma:         "296b0e45d112d38a67f86727d080334b73c5e490253d80af0871ef977b59bcbf"
    sha256 ventura:        "aeb6b7551e17a0b2f2e055fc0054f6852e0d2d05dc7711d94defc9925c3a8d8b"
    sha256 monterey:       "d6346f704603a9b8d632a532948e3b7f7cdcf6f1a0a95909912717342d645042"
    sha256 x86_64_linux:   "ac33f0dd21e03ceec2d00c43d6658ff2e940d770fef858890f3502d27c3c2a12"
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
