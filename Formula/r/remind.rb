class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.00.02.tar.gz"
  sha256 "5f1563015dd31833c8f176855d74a68a7b0c7dfabc9bc963c3af183080b69588"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "3f9e62bbaaef0ece623f562533a0df6733e3ecfb46412de15fd5853d3ba87582"
    sha256 arm64_ventura:  "7eff94c4e93eb9b5b9c59c6bc99c93237b4a5ca396816e7be533b75bfcb14a2c"
    sha256 arm64_monterey: "f29a9bce751b0f3e79c2f45713e774934c716c32adea6c286c31eeadce5d931d"
    sha256 sonoma:         "058d7a57c983e35c0f4159fe2a7723cfcc41f27649e3fcb4d8ff8daf4e095d69"
    sha256 ventura:        "608146c39dc860aa4670e01209ba43de100c40191348fe93a9c3006f8da8200c"
    sha256 monterey:       "e3887239bd0493280c78788fd05415decf3a22a5f5cb55f44919db02aadf5a16"
    sha256 x86_64_linux:   "8d800f04873005670ad10c8c8acb8d79ccda1402037f057fb73a392428650684"
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
