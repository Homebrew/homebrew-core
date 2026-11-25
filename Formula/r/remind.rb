class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.03.09.tar.gz"
  sha256 "a26c028458fefe6bd3927d95d9673389847eb44ff9bc810e3f35dcc82b442433"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    manifest_sha256 "d2fa3273cbe0b7977f9a4f31df9c098c5ee92e311f7195163423a512ba92ff03"
    sha256 arm64_golden_gate: "dcd529dbb430daec0458e58a7b3eefac4b7360c98a0530ae5de9678f50be55ad"
    sha256 arm64_tahoe:       "d5b3b03b0e779208ed5d16d99ad351f7279859cf7b15dd90bc2f2dc792d593c1"
    sha256 arm64_sequoia:     "0f277fcbcd84f4e1b5d91834b72c6ba8727cdbc56f0abb1883e9bb8374dda876"
    sha256 arm64_linux:       "4a8dc1012800eb4ed7876f07711435004ea62d798f371b9a2f3e0f0f1164f17e"
    sha256 x86_64_linux:      "2855eda133c77a791e3568b163cac082d5352294d16e8061f273158173f1ae8f"
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
