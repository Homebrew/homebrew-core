class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.03.02.tar.gz"
  sha256 "a1c783cd0c9bc6958e1e01e8970a514249b0a7a01349d5d1639f2dace7bcf585"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "ca711e1a785db1bfd90df06e8e18118303d95ae4b153e0c2a8e76cffd1914827"
    sha256 arm64_sequoia: "3bd4482d8a68e0db662852aeeee9f71cfbd6667af450d73bf433e125cd9996e1"
    sha256 arm64_sonoma:  "04934b7b32830f689b0a3aab92cf9ae362c6828abb085e6b1823f442f84d0313"
    sha256 arm64_linux:   "2872be9f8fe9b55e09748f675f15f09b17b4db2ab7d9b4e4128ff6ab71bddada"
    sha256 x86_64_linux:  "59b937e4616a1a911014433efd1de719fdd231b5bb81c8f53e2c0797e8c0a84a"
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
