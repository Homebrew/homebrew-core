class UsbIds < Formula
  desc "Repository of vendor, device, subsystem and device class IDs used in USB devices"
  homepage "http://www.linux-usb.org/usb-ids.html"
  url "https://deb.debian.org/debian/pool/main/u/usb.ids/usb.ids_2026.06.26.orig.tar.xz"
  sha256 "bbd6b4c8d9fff1e2602551b6a73b8ca0475d1aed93a1807d680d02556c49f8e3"
  license any_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  compatibility_version 1

  livecheck do
    url "https://deb.debian.org/debian/pool/main/u/usb.ids/"
    regex(/href=.*?usb\.ids[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c9491342e01272aa6c99d7a721050ba0aea50334eb462541d2d657ff8b74707e"
  end

  def install
    (share/"misc").install "usb.ids"
  end

  test do
    assert_match "Version: #{version}", File.read(share/"misc/usb.ids", encoding: "ISO-8859-1")
  end
end
