class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.03.03.tar.gz"
  sha256 "6045283b98e004a683b13a636409ba691401d2ae9e5122d244c151972e923341"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "d89bef8a31cb40e4cd7f2d279540a2f70c2c4a3a725c74730129b14d6dc2685c"
    sha256 arm64_tahoe:       "6ad4216bf1bc1de25c706e1b55ba5c1614e871b733ee775ba1fdd3601d169a08"
    sha256 arm64_sequoia:     "2edb4e4c4d1613720d1e9b55dfabaa966e7bec4cac70adf119c5e19f725b6200"
    sha256 arm64_sonoma:      "c3b20268f0656638a9d76350d6c50388f5891e2319d8329b8240e6f6a5a668ee"
    sha256 arm64_linux:       "d555720ffed4fcd5b57d08175fe381fb88770084074b518aaecbdf58403fa3ce"
    sha256 x86_64_linux:      "8a9eda10f991364f432c497b3d9dbcdbf6c6cce451c180bb33052cb5e5022d49"
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
