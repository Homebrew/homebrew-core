class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.01.01.tar.gz"
  sha256 "ece63699bc6cef7a1aca20d90868580d57179298650b3da5d4b7902f8a566693"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "94c3a70740aa3869f87ed99fc2c020ba2836c1b2f1be8a062964ac951bd11ada"
    sha256 arm64_sequoia: "4658a60b6da193c8111834c886fc94c560652a4efb51d07ecb01294af852a34c"
    sha256 arm64_sonoma:  "8573fe46e5b86e70fc5bdc210d1923e9d9a63e679090c0b0f61fde809ac31bd2"
    sha256 sonoma:        "7314ebaf499df53c9f9f139cf31e009b7ab00be0d084f421536268403e48cbfc"
    sha256 arm64_linux:   "369840cbf135424a7092e37cdc62458a94346568ceb7444e5604703ee014a06a"
    sha256 x86_64_linux:  "fe3621a000ab00666bb535888c233bc321b01696e0e51a6f5c7813b461d07cf2"
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
