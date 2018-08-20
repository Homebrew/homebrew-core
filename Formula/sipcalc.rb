class Sipcalc < Formula
  desc "Advanced console-based IP subnet calculator"
  homepage "http://www.routemeister.net/projects/sipcalc/"
  url "http://www.routemeister.net/projects/sipcalc/files/sipcalc-1.1.6.tar.gz"
  sha256 "cfd476c667f7a119e49eb5fe8adcfb9d2339bc2e0d4d01a1d64b7c229be56357"

  bottle do
    cellar :any_skip_relocation
    sha256 "50bc96758ca5ecdb86fb29ca39bf07f6c4e44192310481436afccc191c6f2cd2" => :mojave
    sha256 "9cff165f5e2b98d0c7d4729d4d6309b679cae7d161996242c666053d37134640" => :high_sierra
    sha256 "1ccdaec0a816dde9f7caa0f7a77cd984ece78a61a5886032c4c8821915753482" => :sierra
    sha256 "56aa686252ac703ed3dbe91f5737ec4d4b95d52516f4ab52947df15b77d1c58f" => :el_capitan
    sha256 "6b2fc300755693d382fd5ea971c272a7c8c7bff49614dd88d8db4270aa496012" => :yosemite
    sha256 "7ddf7b200984de97143828faf6385314a2ff3f4436432d810e5aaf7dfe44e78c" => :mavericks
    sha256 "be6f69bdc8613a2f6f98279445ac443517b7ffb2746268c09e0d2cdc61bbd0e8" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sipcalc", "-h"
  end
end
