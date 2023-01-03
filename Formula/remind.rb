class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.02.02.tar.gz"
  sha256 "d5571f260f83fc152d2181c92c66b8d368fd166c7fc1c0fc7f81578f59e7218c"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "55baa90558225a5fb4aee0a926377c3e2f2fdb693addad7d0d2eeb94f79d40d1"
    sha256 arm64_monterey: "577b9ac07e4dc6d3b759f5cdc9cf5620280ee00ed7db57f2a67101d558455dc3"
    sha256 arm64_big_sur:  "c92cdafd099a8cb21af2c376831469179483e22e242d7d1a153f9bec07d9e126"
    sha256 ventura:        "3e36170c90042715761bfa71c2e016a965e700b5f6482ad7fc2187464859c80e"
    sha256 monterey:       "4e9801712aaaed91d21132747c9e9842f73a3def4fa4d80b0c652ab3ffba427c"
    sha256 big_sur:        "a844ce7eb498bd071c86f9f80cacef932080477454a0b6551c2eeea96814e2bd"
    sha256 x86_64_linux:   "4b20451c7506a1d0954337792ff28fbe2ea3c160a3df13893eb17d0083759bd1"
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
