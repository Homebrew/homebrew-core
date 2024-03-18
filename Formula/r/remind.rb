class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.03.03.tar.gz"
  sha256 "fbfbd7e8dbb417ce2665c12777d8c595a54a6c921040e2623ecc6ca4a17e9254"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "81c9a839ddac1b3e02d758d8613e51f67e7888cc8627bc1c5b26ece5823f4dad"
    sha256 arm64_ventura:  "6530f9cd2303b03295f3d00a83e25c21b71d8bf13c18997cdd3c20e452bdcbc8"
    sha256 arm64_monterey: "67da28cc5000911d642672cab3bfab94c144e511d5ef316a887d7b71e55ae3bd"
    sha256 sonoma:         "4744fdcb7bf612f5e1525784e60a5c4f76b45dd9761ff9b18677c28b8cc521af"
    sha256 ventura:        "933194df77a5e30e344c3c90b9d7fc9a308337d8643554c60f60f8bd36a696b9"
    sha256 monterey:       "6a89d6ada969aa9dfab4bd562ecde47fc310fd769a77b5312640ac94f4d76f45"
    sha256 x86_64_linux:   "f57b0fffbaad65f81ba718702a4e4a2dfac0d663907f9170607abcfbb7874db5"
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
