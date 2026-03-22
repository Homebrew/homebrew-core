class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.02.05.tar.gz"
  sha256 "8124d0a057aebfaba30eb63a8c331b3c5e60dd15d24d8e6492316d1536e36305"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "879c816769dd9c0e6aaaf3f81a97a080dbb569071868b32b85894a4e37e3ba96"
    sha256 arm64_sequoia: "2ac3bbacf404b75bb51bdd84aa11072cb5b2dd8dae9ad446a2dc27df8831f66c"
    sha256 arm64_sonoma:  "b1e0cffbe1ef85c0906c669c191dc27fb999a069921ed1b5a6c6a53ee82efa15"
    sha256 sonoma:        "57aff04f19b77f3dff05cb7461c2dde8666978487c790acd6bdc86b5ee61ca8b"
    sha256 arm64_linux:   "12e530f6f29438a989021783db69941febb789d630911eb8967897f9088d1986"
    sha256 x86_64_linux:  "7cbe9fbc9850ff11ebb9d955f718d502aeadf6f1c1561d1d1b9898e6fe946de1"
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
