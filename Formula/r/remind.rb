class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.01.03.tar.gz"
  sha256 "f7a5b6262970e3cd815a78dda22563470ff435099b8ec2d2a336186d7c236141"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "f49311d4fadb3acbc4b7d838c2e7f41cd8ed5d33901e07070d04660173bdcdee"
    sha256 arm64_sequoia: "b9737c6101ac71852ccfda5f992a980153e203e0e7526496f0733e0f3ee3b399"
    sha256 arm64_sonoma:  "f6844aee4ca1146eee5a0d9727bc38e9d39a9c58032e17c1f3888494e137fa37"
    sha256 sonoma:        "bcf12894611cb77329cec504950a865c0247b77c69e7c8a6e68e5c68d57d16eb"
    sha256 arm64_linux:   "9e7f61df3ecfddba943eab7d6a5f640d67751699bfdc2dcc052f1c53376d824f"
    sha256 x86_64_linux:  "7aa7b56453a28f341d0eb119a8a49c81ecc92bccbaaefc4da77c6212f9fc71d7"
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
