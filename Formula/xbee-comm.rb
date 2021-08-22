# This fork contains macOS patches.
# Original project: https://github.com/roysjosh/xbee-comm

class XbeeComm < Formula
  desc "XBee communication libraries and utilities"
  homepage "https://github.com/guyzmo/xbee-comm"
  url "https://github.com/guyzmo/xbee-comm/archive/v1.5.tar.gz"
  sha256 "c474d22feae5d9c05b3ec167b839c8fded512587da0f020ca682d60db174f24a"
  license "GPL-3.0"
  head "https://github.com/guyzmo/xbee-comm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a4dda0f81a92b04ac242a71d3b233da85abdcc767b8c5ec956e3285565eef994"
    sha256 cellar: :any_skip_relocation, big_sur:       "9d163cd9e888a337b0bc39bc3af871a0ed0b8efadb75933e4a4273fbccdfd90d"
    sha256 cellar: :any_skip_relocation, catalina:      "4c4eb5e75f59ac2527ec72d41e5e11ae156243278b7c92186fdccec62435a783"
    sha256 cellar: :any_skip_relocation, mojave:        "c5358f469073875537f489d59525c3c9022cebbd3fb77f418b4abba96cd24bf4"
    sha256 cellar: :any_skip_relocation, high_sierra:   "935948849935f3f11e6cf8992b1c6ad79e92716583c6b5685bf55cc6c4bd2d7a"
    sha256 cellar: :any_skip_relocation, sierra:        "9f6d626176e06f69934f3a3a3c56ddfa6a02be4f49d2e53dbce9d92b17f9eeb0"
    sha256 cellar: :any_skip_relocation, el_capitan:    "64b15ac79da143e2b092db702fd22c92ef064093be1c4c81cb60fd5b08f44075"
    sha256 cellar: :any_skip_relocation, yosemite:      "805e99d4e700a2e9993f26fbc48cae17c1bf16e6ff9ce63b5c7195358fcb052c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf23d16b599dc5427dd3552004d307bacd82b77b89ac2bd0a018bf1f986fc720"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "aclocal"
    system "autoconf"
    system "autoheader"
    system "automake", "-a", "-c"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
