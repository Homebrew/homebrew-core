class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.03.00.tar.gz"
  sha256 "a4e69c177b7e64a291f8d4d540fb05adb94d87ef173667ca7955e9c72dad5968"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "4bc1e4a34ba8d04654e14f4339c957dd236206cd2dd6ac40c21dd2cd86d7e123"
    sha256 arm64_sonoma:  "5ce24e7dc68aa6439013da7d295b64da2abe352593d5ca2731ddd8188cc16d18"
    sha256 arm64_ventura: "1f13da41c69d7726a80e0867d7239210733716da6524348a25c47a9c1cc2dbb1"
    sha256 sonoma:        "4cafb87c1b0a2dbf899563ba047fa26707ba38e01110d15f8974de6c70c9e950"
    sha256 ventura:       "f82b0b1d13145f4b5fae4b64aefb2ebb98a16aef4961840f0805eb64b26cd8bd"
    sha256 x86_64_linux:  "f3c27e44fce893f856aa8a5e9162c52f825cf5d0d29dfe502676aee8a502f2d6"
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
