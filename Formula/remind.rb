class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.00.01.tar.gz"
  sha256 "3615d2ed6a456cab911620160d2cbe83d3e861541ca6e80ba6940417f4b959e2"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9573483c77af49e52088d766d3c0f548789f3e709d4ec35a35653d3c68711024"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7066f56602d865a30b595cd90f847cf1a5cddc9d9122701bf5ef4aaa13cd785"
    sha256 cellar: :any_skip_relocation, monterey:       "449e45e90bd3764aecb2deaa736563d6e18129cabfa7537204fbb32daf4a0d1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fed7ca6f5f2d6cbaa515cc7162fd63816a9c6272521d42d3e07539d8174ebeb4"
    sha256 cellar: :any_skip_relocation, catalina:       "50962095453bfac586ae0977e6bb7fa309344f756670e43496e97ba1a075ac07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22a3a3df2462715a1107fd0c4811808545b1d9986240832e50b3e15b3b37aa1d"
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
