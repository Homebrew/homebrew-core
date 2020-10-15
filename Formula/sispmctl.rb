class Sispmctl < Formula
  desc "Control Gembird SIS-PM programmable power outlet strips"
  homepage "https://sispmctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sispmctl/sispmctl/sispmctl-4.8/sispmctl-4.8.tar.gz"
  sha256 "0f8391f7e95cbf1fb96a68686a1dcf1e16747b050ae1b8ff90653c99976068db"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "2c4a8a22528a34de494a7e5f93873f80cf4bc47646e725baddd86bb2d242ade8" => :catalina
    sha256 "ec93867cb3b46835c74d640fdb329735b15cb4b273b722cb5855808a764e27c9" => :mojave
    sha256 "1d7c6d1b3e44399b748f6e47d08e8b381ac9685cacd2d0993fbdac140760cc4b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sispmctl -v 2>&1")
  end
end
