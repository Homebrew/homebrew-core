class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.02.05.tar.gz"
  sha256 "9ce105855c19be052877e8ffe627e59458134bb23cfa138078c4839511f8f808"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "5bb71ecc55b554a235983bb2cd741edcda11fd4538c3447cdaf265d6586ec54e"
    sha256 arm64_monterey: "28d65fb187d408d886d75e7a2a7908a25154868d71152c99db6606e51e8d5c72"
    sha256 arm64_big_sur:  "17af51232e21084f5ad6c7cf9f7392bf0077d758106fc675bca315b84a601c58"
    sha256 ventura:        "84bddb98941ebfa77ef4959c17bee80f6120630a7313e8fc970edae5252aed78"
    sha256 monterey:       "55b6f9e927c170169e2f2c45a43b5000630697111c878511353d74ebd176207b"
    sha256 big_sur:        "901068868681c343d6a31f3b5a75fef3b1527738fc8749824436f55be183ff74"
    sha256 x86_64_linux:   "a8095347b8e72958a2d38470ac12da627b507fc6e6e38c4527beb3f6a57c43c3"
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
