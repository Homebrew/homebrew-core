class Reaver < Formula
  desc "Implements brute force attack to recover WPA/WPA2 passkeys"
  homepage "https://code.google.com/archive/p/reaver-wps/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/reaver-wps/reaver-1.4.tar.gz"
  sha256 "add3050a4a05fe0ab6bfb291ee2de8e9b8a85f1e64ced93ee27a75744954b22d"
  license "GPL-2.0"

  bottle do
    sha256 arm64_monterey: "c5aebd64ad2c3055146fea9e91914d689914d1aab4e945f354264183a190bd97"
    sha256 arm64_big_sur:  "c4ba873b94ad8d7f968474660417e7af8ea607f9b42d3971533f84377a56a3d2"
    sha256 monterey:       "2c8d6a61a5f75a853946a9f982c81b7d1c37f5ddd9fafaf61d862bb2dfb24be3"
    sha256 big_sur:        "0cd13169a7c0f7603fab7ec7ac55e8896ffd5518c4e790a59183e894291a5cab"
    sha256 catalina:       "73539f97836b5df80e030e429eb7f209dec3067c14b1bfd6753bcf7796c1f541"
    sha256 mojave:         "386ed8ae2562ae032f0d622d52d7302be2e99bbe671f1ca5ba3acb88b86f6417"
    sha256 high_sierra:    "c2c6d45abc45f5639b74da0bdb294a5ee83548f548642f6b61d764d05801352e"
    sha256 sierra:         "e7fc0f43b7a306d5fe2baaf4b41e9ce445db12e2e74d41904b3de5d2c372741d"
    sha256 el_capitan:     "d9adddf27928b284492cc87b565d2748490c1017b0b463bc15223c935f63bb6c"
    sha256 yosemite:       "4fbf7b0225730d7a37bfb71bec7b99f78f0b0946df7bcb3e5f274795692e1b3f"
    sha256 x86_64_linux:   "1a1e6c2edefa97af1a4295d859695c6dbc055a47676f9ec845916362bcc884f6"
  end

  uses_from_macos "libpcap"
  uses_from_macos "sqlite"

  # Adds general support for macOS in reaver:
  # https://code.google.com/archive/p/reaver-wps/issues/detail?id=245
  patch do
    url "https://gist.githubusercontent.com/syndicut/6134996/raw/16f1b4336c104375ff93a88858809eced53c1171/reaver-osx.diff"
    sha256 "2a8f791df1f59747724e2645f060f49742a625686427877d9f0f21dc62f811a7"
  end

  def install
    man1.install "docs/reaver.1.gz"
    prefix.install_metafiles "docs"
    cd "src"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    system "make", "install"
  end
end
