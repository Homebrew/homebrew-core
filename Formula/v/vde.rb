class Vde < Formula
  desc "Ethernet compliant virtual network"
  homepage "https://github.com/virtualsquare/vde-2"
  url "https://github.com/virtualsquare/vde-2/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "a7d2cc4c3d0c0ffe6aff7eb0029212f2b098313029126dcd12dc542723972379"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/virtualsquare/vde-2.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "7d38316ce1948eb727d590d88e81fb5c74f2ae4f0dcd9b7161266a4af1ff2e3b"
    sha256 arm64_sequoia:  "1e3ffe05a0f354b3909f74d3374fc036156c438147f5ac8dd34a8f747071e9f8"
    sha256 arm64_sonoma:   "3d2231810ad7229ba6a68178d648ab1f13bdfe50b214cb2d299d644d66e03762"
    sha256 arm64_ventura:  "982a56825cbd1bd374001330e3492e83a1d82825ed7228d33705ffad3b927e8e"
    sha256 arm64_monterey: "0cd674a5b677c8e4deb2735884366f6a384b0867aa7483e7293e361cbaab350e"
    sha256 arm64_big_sur:  "55d8e9f7b7e4f4593c6a3a4c88f4d6f11c76a8839b876fe63cae40d01e6312dc"
    sha256 sonoma:         "9015f4eeed08db31898c74789119cbc543776f6eb13f4428da554f5d240c1697"
    sha256 ventura:        "e203e8f3933c5dcdc45cdaae85f63b31ecd38a86d90eb5f4f0c1fd7825ad2347"
    sha256 monterey:       "88cc1ceea76bdf304ec6750a2c54c979b34869d853fe6942aff1b23ea213f83e"
    sha256 big_sur:        "05e4b0a57c14a91bf9fbf6afc1cda903fe07504da5545ba4de72c7bf09d53893"
    sha256 catalina:       "ff106fafad478b7380d270d0969584e753b0f3592f59b2f43dca8bc86246b2e0"
    sha256 arm64_linux:    "522952a405fbeafae167b3a044c95156d29ee89adbe317818906e750c0edf557"
    sha256 x86_64_linux:   "d9ab4e00d44ce831749d0d4363ffee5332295292a5ebcf2d5379d64796b549d9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"vde_switch", "-v"
  end
end
