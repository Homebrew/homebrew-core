class UsbIds < Formula
  desc "Repository of vendor, device, subsystem and device class IDs used in USB devices"
  homepage "http://www.linux-usb.org/usb-ids.html"
  url "https://deb.debian.org/debian/pool/main/u/usb.ids/usb.ids_2020.06.22.orig.tar.xz"
  sha256 "d55befb3b8bdb5db799fb8894c4e27ef909b2975c062fa6437297902213456a7"
  license any_of: ["GPL-2.0-or-later", "BSD-3-Clause"]

  bottle do
    cellar :any_skip_relocation
    sha256 "86ee1383749511bfa93b03e04b34e99f405abfbe791df50be85f992a303965c1" => :catalina
    sha256 "9acaeabecc451f483976baeee5967a6123d4945b3227942b15ecec8bb390e44f" => :mojave
    sha256 "cb6f7ce696f58356e9ab5679ac4dba62f66d597dd62eacdb64e94e94c10e5be8" => :high_sierra
  end

  def install
    (share/"misc").install "usb.ids"
  end

  test do
    assert_match "Version: #{version}", File.read(share/"misc/usb.ids", encoding: "ISO-8859-1")
  end
end
