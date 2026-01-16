class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.02.02.tar.gz"
  sha256 "3cdd8f4060ffdf644f3964ca67175c4fb54e668c4de5aaedcc9c064d73d86db4"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "4a5b14bfd5c2a54e0e47e384f231b86bfe2a3edc86389e245f46ca022eb1f87b"
    sha256 arm64_sequoia: "a20feb056316ef8da9707fde63ac4f6cd22a72b8abbd9eeb4088b412898b8347"
    sha256 arm64_sonoma:  "acaf56546a03285582cf2afeec4d7cd1a1f2f535ed95fd3ed5ac4876b8f18f22"
    sha256 sonoma:        "3780745f14b78dd7405293a19416343175de3a4ff6f31409a5a41a5ef91c3c05"
    sha256 arm64_linux:   "1ee79cea2ba9fc237430427d8870aee18891f75611d03f481ba0de9df1a88560"
    sha256 x86_64_linux:  "cfaaffdda7f598bda854cdeff8c7299e7e1ffcd0a967a311d210ad7aed10cfd0"
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
