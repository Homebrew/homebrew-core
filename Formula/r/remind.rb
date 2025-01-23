class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.02.03.tar.gz"
  sha256 "74615cf80fdb52caafef0730ffbc1c460f905c9b1d01ce218931baef2c4e278b"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "a268399dbccbe4f26ff475ea6553d4df6993e99b47c091bcd0bafb186123a88a"
    sha256 arm64_sonoma:  "48ffedd31643a42652ff0179a29efc7357c5c6e274ffdd3b206a508dca246df1"
    sha256 arm64_ventura: "eba927e1b1c6027adf70da86e3cf320618141a0bd8b2520c3721063bb9f78fab"
    sha256 sonoma:        "b1bf9acbb88bab266122efa63c92b0cfe4ae7c5dc0b52a4e33f394f3f624a8bd"
    sha256 ventura:       "43f1bcf21bf78b5acac288c89ad6f983f4d63123c567c52b0c57fbab29626200"
    sha256 x86_64_linux:  "8fb6a928b4baf8f47ed50bcce801557e67e9f4640e2d72f4dfbcf16cb26b1965"
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
