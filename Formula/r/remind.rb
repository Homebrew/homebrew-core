class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.01.02.tar.gz"
  sha256 "45c08228a0aa78fbcbcc6c8259236c25b12a0aa802477bacaadf9a3d5a09fd28"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "7f54c5634ecae0365289fe9c9e047181d7c7d0a53fd3753096c50ea1b3e39e45"
    sha256 arm64_sequoia: "21cf0a0216692a8703390c63338a81750329067aba72c71240b80fe7839ca5a1"
    sha256 arm64_sonoma:  "c31dceb28d30f19306639313a3c0c91618357a0e8a93e0b1d50f577f9b1c8ebe"
    sha256 sonoma:        "5db79e13fad435131a9e6f70219ac8a6b37e993b7f502332e50b52c4b0150f1a"
    sha256 arm64_linux:   "e1f035f1907a53e75ce737ce2e2ece5da90caf5a8a954f426b7ee37c3b62fe22"
    sha256 x86_64_linux:  "e6c720323855a952b9ef6d543c46f5bb297040e70c82e82f3773115d62c65719"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    # Fix to error: unsupported option '-ffat-lto-objects' for target 'arm64-apple-darwin24.4.0'
    inreplace "configure", "-ffat-lto-objects", "" if DevelopmentTools.clang_build_version >= 1700

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders.rem").write <<~REM
      SET $OnceFile "./once.timestamp"
      REM ONCE 2015-01-01 MSG Homebrew Test
    REM
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders.rem 2015-01-01")
  end
end
