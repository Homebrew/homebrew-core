class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.01.00.tar.gz"
  sha256 "3f46839841e4c4c1a4de0c200f014894d3682ce7d265f38753555842438b4061"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "0dcc714622c6e79cf665a69cb9ecaccb5d4e9985322f1dd84d511329c0892e9f"
    sha256 arm64_big_sur:  "2ee39daf9f277066c0ea76b9b3f5a21d72cbeca1cf69466b1842a529eb1913f5"
    sha256 monterey:       "c3e48c285ac06fd04fd5ada07a159dc72d7d86716d04a0addb04584dfaac58d3"
    sha256 big_sur:        "bf5a719dd6e8557adc3203ca99be06a410adaebdf3dcc054f1005c98f4aec804"
    sha256 catalina:       "485dda1beadad00ba6da6fa7919c8fd1ec8d4d984498bb03b14aa615cd13e2a7"
    sha256 x86_64_linux:   "e39a2bbcd33ef1f68781a1111e92a616d8b5733cc59fed3d4d80cb80d67d9588"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end
