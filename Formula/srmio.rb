class Srmio < Formula
  desc "C library to access the PowerControl of a SRM bike power meter"
  homepage "https://www.zuto.de/project/srmio/"
  url "https://www.zuto.de/project/files/srmio/srmio-0.1.1~git1.tar.gz"
  version "0.1.1~git1"
  sha256 "00b3772202034aaada94f1f1c79a1072fac1f69d10ef0afcb751cce74e5ccd31"
  license "MIT"

  bottle do
    sha256 cellar: :any, catalina:    "f545c95e5fb1bbcdfc524ac0c6173ad3b95da632c68803cddb1423a0fa66d9be"
    sha256 cellar: :any, mojave:      "68a96377224e3eaaae6bf5b2fd984d7cdbbf62a094a52671c2e260509577e8c9"
    sha256 cellar: :any, high_sierra: "5d46a88acdd891c6ab67c32215a80078946495949891c1181cc00abdda972800"
    sha256 cellar: :any, sierra:      "9ca9c4a2d17c7f431b1ad9899ae97ea22ec44e24a9c0c60220638c0f31f9b2c4"
    sha256 cellar: :any, el_capitan:  "9e45cba0daaa89683552f1feb19cd49c42d27a311113ecb204ae8c2e48231f3f"
    sha256 cellar: :any, yosemite:    "e71a6c2fac5115cae2fe1a8b7eea9fb5800b96f908adf357a667b5df70bd7089"
  end

  disable! date: "2020-12-08", because: :unmaintained

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/srmcmd", "--version"
  end
end
