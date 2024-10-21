class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.00.07.tar.gz"
  sha256 "89ddf2572287452256866f2be1999cfe4eb501952dd706b7940ad092d0dbb7dc"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "faf4a5bce9783b078d5de8023f6594625ce5581b88e896a9345dbc76f1c8e1cd"
    sha256 arm64_sonoma:  "3053c160dfe9a926fe66c0a4155da07b9ddc6605a0cdf6942e9f4d855c728aaa"
    sha256 arm64_ventura: "f6cd9737ce3b3ec3fc18817aa4a75c2fecbd10589e1e23d2c41f71335cdb02d9"
    sha256 sonoma:        "8263bf2271072432dc48b1c5f7e8493f544359ff5fb58b99c496390e5e9a422e"
    sha256 ventura:       "2b4606ecef6e4cd8560a5f3f4b67f6ef3b7055d91e767dada8e15d9647cee593"
    sha256 x86_64_linux:  "d00f1c6437745bca6fb5418948a3056659ecf0900f8ada3a96074dc3003580ab"
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
