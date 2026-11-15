class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.03.06.tar.gz"
  sha256 "19518dfa6ab3695749e74b26b664a7134b573ddd03f0a7a6fee3867868d6fd58"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "babe2446f0521e5fb41922775a5613ef88426425087a32e747097d13088c0ca6"
    sha256 arm64_tahoe:       "7e31dbd119d74b26f6160ad07af51b3bc09b1ac53dc098916cf7d20cfec4f544"
    sha256 arm64_sequoia:     "437b2a0ed70f9a062a75a29e377b650b729d9768ab81c89b035930dc8c13af08"
    sha256 arm64_linux:       "b1cecebb277805bcbe49c6b41d86ce2c4ee6f396ef9dc77df142b6efea3e05e2"
    sha256 x86_64_linux:      "c26ddac8a0b8a4f9a8e14fe23604cdb0aa0ee0b6584200bbe83e4275235477d9"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  deny_network_access!

  def install
    # Exclude unrecognized options
    args = std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }

    system "./configure", *args
    system "make", "-C", "src", "install"
    system "make", "-C", "rem2html", "install"
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
