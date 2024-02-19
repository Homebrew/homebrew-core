class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.02.09.tar.gz"
  sha256 "64468460b405a705dfa7b38db14b7823f10da8f003aeea281517ddb4986b872a"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "a6048f226945eac86fbb0fe0db2faf3199185266502bb6c9255dc9ac177ec568"
    sha256 arm64_ventura:  "0909dede0d9b1d9bc36df97395fa5556be11dffc1075481d8f37936d2eebc0b0"
    sha256 arm64_monterey: "e3624f13ac1b28e613c296e17f19fe8e603db313504cd4efb2485960dc18710c"
    sha256 sonoma:         "3ef3b45f261fcbabf08ab008132766353f925b5f55c5aedef540c52a585efb7b"
    sha256 ventura:        "7b9e3ff656644b96bed51766c8bd341a1aa041c8e80f6c209929cc61695857d5"
    sha256 monterey:       "e753108b6481e0ab9afbd6b98e81cb8d8fe361e67f3451abf0e79babb69855e6"
    sha256 x86_64_linux:   "ce532dc01066836deb7535bd9cfadc48f3bc2a78b9f784e3a566160c45514968"
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
