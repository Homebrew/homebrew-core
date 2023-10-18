class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.02.07.tar.gz"
  sha256 "03e12d90d99039ccf731be2aeea40634bea9c829d1bace27a8da2be3ce6db190"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "bed0f252ce2fb566d7f1d17f236733271881cd30077dfc997be86b878f43f0b8"
    sha256 arm64_ventura:  "7f35831528ae7c83b2dad8cc73b29859384f4648f6fe913a62535f192702c0f6"
    sha256 arm64_monterey: "29d0468f9913e396029378b7ac6c6781d58d6c63e94d2d49665aaa715cb8e8cc"
    sha256 sonoma:         "ac42ab4ba826f888d02f8696029195807814b69eb67a8498eb9751f028a840c0"
    sha256 ventura:        "67d9a8da0bdaef6539ba2e4e84ab0793200995e2b03c5bb7aaeead46ecfdcdae"
    sha256 monterey:       "cda64f783b5d935c950cd878ab55d39567c42570612cc760622d5c50f6cca06c"
    sha256 x86_64_linux:   "32753bc8a80d10ff96fda10a5a30c25c646546bb2a33e32add382f3bea4f9b9f"
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
