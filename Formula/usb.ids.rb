class UsbIds < Formula
  desc "Repository of vendor, device, subsystem and device class IDs used in USB devices"
  homepage "http://www.linux-usb.org/usb-ids.html"
  url "https://deb.debian.org/debian/pool/main/u/usb.ids/usb.ids_2021.12.24.orig.tar.xz"
  sha256 "b8194cbc22b14afeee91e98247cf30d92f1c35be7adf97ecbfc303628942ebbc"
  license any_of: ["GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://deb.debian.org/debian/pool/main/u/usb.ids/"
    regex(/href=.*?usb\.ids[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "062cf6ad3c89be759bd58fbaf5fd2f237a643bd2a3a5672919355cf5c8a1a718"
  end

  def install
    (share/"misc").install "usb.ids"
  end

  test do
    assert_match "Version: #{version}", File.read(share/"misc/usb.ids", encoding: "ISO-8859-1")
  end
end
