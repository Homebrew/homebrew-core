class Sispmctl < Formula
  desc "Control Gembird SIS-PM programmable power outlet strips"
  homepage "https://sispmctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sispmctl/sispmctl/sispmctl-4.10/sispmctl-4.10.tar.gz"
  sha256 "e648b6e87584330a0a693e7b521ebbc863608d6c97ef929063542b459d16bc6f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "305de946ae0b0ccc8ed6b7703bf59730852904f209db2670771ccf1ea5fb8c0d"
    sha256 arm64_monterey: "ed26829f844e176487911032144bdcefffac53d528b6613387060cdf804c3ce5"
    sha256 arm64_big_sur:  "4e6492d30b2625b3c117b12ddf23d0e12e9cce5c9e0d7f2ae4806a0b9227154d"
    sha256 ventura:        "3d58db866b5a5091b90713d63a9bafede0e43573970a8cee9bb99d2df717f0f6"
    sha256 monterey:       "14bd73d5af83b488d1d629e61b30c5356b4a61cf60af92673af41d3269d1c9b0"
    sha256 big_sur:        "3c5776d579886dae1c1c79dfbd00e0f62009b5b36b369ef5cb17866eeb48e54a"
    sha256 catalina:       "ca5277017192e749e693430127f13263e8eb78bb37c462dc613ffaac8fd036c8"
    sha256 mojave:         "751addc56782d7d36eabc1b244413c7e30db2674117ca4bdfa501a23882ff84d"
    sha256 x86_64_linux:   "77b95926b04f52d79e6f11d5ba03276dac6eb74de675150341161b22709bfd64"
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
