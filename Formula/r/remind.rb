class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.00.06.tar.gz"
  sha256 "b861a1d5e44f4fa6c6605e05f5eefd0fe68c9e9390ba492d96625bc8cdae45ca"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "6dbfc52304409b334a566ecdcfd909f3e84ca55744d3efee5a60ec47129e935c"
    sha256 arm64_sonoma:  "6964936e270bae2211787139ce2b1537f848cf19e0a887a17c10d36f7b53a781"
    sha256 arm64_ventura: "9e489e10211bd3fe609d5e95b546abccb9315785524bb0b9e1275103eed11b71"
    sha256 sonoma:        "85bde519fd4ee68c9541a795189018452a599b40ebc7c4cc77c7955fce8ae74b"
    sha256 ventura:       "cdb3314524948d539d4fb1264fdce7b59499c673ad7f4a3d1299c75d998ea85d"
    sha256 x86_64_linux:  "6bc46b925d1d6c72b9a126c09c4097cb81c3ea9900cc524469d423bbbc036897"
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
