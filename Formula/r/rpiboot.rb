class Rpiboot < Formula
  desc "Raspberry Pi USB boot tool for Compute Modules"
  homepage "https://github.com/raspberrypi/usbboot"
  url "https://github.com/raspberrypi/usbboot.git",
      tag:      "20250908-162618",
      revision: "d90eab5130c4fe4a6d92699e5268c1956f46939c"
  license "Apache-2.0"
  head "https://github.com/raspberrypi/usbboot.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(\d{8}-\d{6})$/i)
  end

  depends_on "pkgconf" => :build
  depends_on "libusb"

  uses_from_macos "vim" => :build # for xxd

  def install
    bin.mkpath
    system "make", "install", "INSTALL_PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      To boot a Compute Module with the default mass storage gadget:
        sudo rpiboot -d "$(brew --prefix rpiboot)"/share/rpiboot/mass-storage-gadget64
    EOS
  end

  test do
    assert_match "RPIBOOT: build-date", shell_output("#{bin}/rpiboot --version")
    assert_match "Usage: rpiboot", shell_output("#{bin}/rpiboot --help")
  end
end
