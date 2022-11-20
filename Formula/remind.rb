class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.02.00.tar.gz"
  sha256 "a6476cf0dfe71bc4668e774669100c58d68b68dc6ccf08ca7ea9fa3345e72739"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "c2a1bcba977aababd25e119a83616cbac66d72356e93d33c95309a22fb9cc47d"
    sha256 arm64_monterey: "57b522818917aa6dec6a28809c4b805c3b558fead531fb0fa9da448c415fe8c0"
    sha256 arm64_big_sur:  "730775e3d26daf1a7a35f0e746b42db40dd1595e528aeb3a17bb44bd92510706"
    sha256 ventura:        "4d4b1976006f2f3b998bb39f21f2e4a60857076e850de8cbc810ca1949910f1e"
    sha256 monterey:       "57afc2cac915902842d0c1aaeaf280801e74328978efd371fc86d4135d0ecc63"
    sha256 big_sur:        "d1610819c3951655ebc9cb637d41462a9459dacd18675735e75ddf0d87cd4c15"
    sha256 catalina:       "0be7f6a1bbc14850a2d4ad39b43783ea6acc4f991d3d8c0b15a61917b3ddfc9b"
    sha256 x86_64_linux:   "15b9fd47be67f496d6019be45856a4b200f150fe2ff64aace9b49a21287fd50e"
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
