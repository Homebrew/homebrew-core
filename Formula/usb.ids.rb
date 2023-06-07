class UsbIds < Formula
  desc "Repository of vendor, device, subsystem and device class IDs used in USB devices"
  homepage "http://www.linux-usb.org/usb-ids.html"
  url "https://deb.debian.org/debian/pool/main/u/usb.ids/usb.ids_2023.01.16.orig.tar.xz"
  sha256 "e3fa8aee278a02ad63759ff1db9aa556164ea42f5b098c2bc1e9f2a6c1edf390"
  license any_of: ["GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://deb.debian.org/debian/pool/main/u/usb.ids/"
    regex(/href=.*?usb\.ids[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7696bf5ca3310cfc6af015d1e5d3b4c9448afbda0cf68286f8a3538b766c012c"
  end

  def install
    (share/"misc").install "usb.ids"
  end

  test do
    assert_match "Version: #{version}", File.read(share/"misc/usb.ids", encoding: "ISO-8859-1")
  end
end
