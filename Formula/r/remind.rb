class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.02.08.tar.gz"
  sha256 "eb69645eb64018e9a2ee10b4d6fad4744a99dbf63dd2bdad7f92d910d1f6d264"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "2972086384956d8a165df30d4e8f7f7dd2e0ffe1d89ba4b0e6a684a847f93fbd"
    sha256 arm64_sequoia: "aee465bdd4242e2fc9fbcf8fb325dff6e8191e8ad4c49b07a5494260adec36f4"
    sha256 arm64_sonoma:  "6c73d66c9f6cc81ea731fa912fc8834d4f74a250b3a1bf6f3706c3822ff4932f"
    sha256 sonoma:        "e963727dd32bdb378993e8fc157a7dac250743dcc3917b93e6142a9542ef4893"
    sha256 arm64_linux:   "ab390572b2dbacc55d9e22597ed3b8b34c78fa24b26fbbb06bcefeea3ff2eca9"
    sha256 x86_64_linux:  "2ec7f52ac9b030d220c8fcec5f04f142b1c33a203c287b73eec376409d085b5d"
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
