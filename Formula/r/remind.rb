class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.02.04.tar.gz"
  sha256 "c14fd9547c5aa49db6864043e0ff04d3be8713a0b795dc0df561304ec1cd3536"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "64c20c6f31569ba576005767e590c4c30baded7affd46867d86848e5c5ecf22d"
    sha256 arm64_sequoia: "0bc3b862201f424cf46331b496c7cfe702df9869c6df0530c80ed3c22f0eff87"
    sha256 arm64_sonoma:  "802de03683857354b7632c30bd0cd8257177759c2c713b138c926a6d162aecf8"
    sha256 sonoma:        "4d56cd4c596c58b96d08319e31614e5f857a8488d59ed2b69afa90b5baddabe6"
    sha256 arm64_linux:   "6b2a128272d92572390600681caa39c289a9e4828236479f7d1f9fe34794c790"
    sha256 x86_64_linux:  "a2e24cbd1bbf5b113d619fc997913c304a689fbe4d23bf43b6c136fb0d13eecd"
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
