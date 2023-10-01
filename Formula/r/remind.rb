class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.02.06.tar.gz"
  sha256 "12150b3a1a42ac996dc1efd2abaee7e6100308c793a5c1aa69745f38e4735635"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "4dbe8786d98452b1390523026b7e31ddf8b1aed3bd6f159249bfe3b96e20fcbc"
    sha256 arm64_monterey: "e86736aaf74a58ade5ed53cd466ef33c9c2d0c6398ca20f3d11be035b8db690f"
    sha256 arm64_big_sur:  "052c5b0622a607704ebc997ff93e7c0e84036f639b017b7267fb35feadaa3891"
    sha256 ventura:        "68a6840d0c435361c6c573ac1c988a7fb006a1adc65c4300adecc005bc100e9c"
    sha256 monterey:       "71be33dbd0e83c97fc237c06ebca130937881b13de54cc2c928def10f392f7fd"
    sha256 big_sur:        "1c43d8f5314608d27e0ca2329f581731bb814f428f43026ef76d8c1566fefb78"
    sha256 x86_64_linux:   "1943b27db853ff573c1695b1e5ede8fea2a9dae73385f3d8de0a8f2e59d612f2"
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
