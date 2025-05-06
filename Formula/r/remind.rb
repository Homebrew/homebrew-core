class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.03.06.tar.gz"
  sha256 "ca63c147ccd154805ecb80f85f435d48705cb06f5685c9ac1610c5661427e223"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "68fcb0c79e62b8eece03fab8c180ac36c487fe9326a8bceb13e7a5eb7dbc6f5e"
    sha256 arm64_sonoma:  "b5535ff4f5e8df92af6f1c41fbbd8e1e3b6ce3491a5fe4b6eddb00e5a6a403a5"
    sha256 arm64_ventura: "a21764445f7cd16c81aed35d94aea55bc2228389e85a288709d5c5070238fb6a"
    sha256 sonoma:        "b4f07328738a99e89c0d1b2f9c72a5d5d5dd0592dfe1e7dc81d057113cc621df"
    sha256 ventura:       "83c7fb25e00f57fb4fb6873c5e3875155f51949f1b72fb2c1b5dadc7d96067bc"
    sha256 arm64_linux:   "dfe075261085b85bdaa2ba8d2fe8f5715ccad2000261665221485a583dfa810f"
    sha256 x86_64_linux:  "5f21291e00d464e08a203115829cd8375fd6f273c3270ff700ebaa4e2277942d"
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
