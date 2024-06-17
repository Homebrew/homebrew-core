class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.00.01.tar.gz"
  sha256 "b63dfafe52e7ebbfe190d32b45519744ba90f52c7aa032991de6a3892627f7b7"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "c660859ec4f1ede60318ea71298d1e038863d97869c896ead78ab7f98a5dfac6"
    sha256 arm64_ventura:  "9c25704f59226330979e4c2b88e905cd6f6b4e6186045cbf1e941b88543727c1"
    sha256 arm64_monterey: "caa154d05fde3b422e6e6bef7e93c9e0da64a0ca239ae9f6c0bd0ec8ac4aa4c6"
    sha256 sonoma:         "a879b06d005080991cd5e7812775a491f02481ec7932596c1a6860f0b82d22d8"
    sha256 ventura:        "58393551dd77bfb87896f3f5a089797738346f8797dcbd1d14f6f9cf608f09cd"
    sha256 monterey:       "8f6bc70c9727ced61156c0297d33e07083523c92f1aaaad2e9d1ed082fe79959"
    sha256 x86_64_linux:   "274e584b7e651cdc502d99d53cce4df6e6a652705d1afdf17f204bda84887274"
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
