class Rpiboot < Formula
  desc "Raspberry Pi USB boot tool for Compute Modules"
  homepage "https://github.com/raspberrypi/usbboot"
  url "https://github.com/raspberrypi/usbboot.git",
      tag:      "20261002-115811",
      revision: "51006f8d77dbb99c408737825dd0d57285b7d00d"
  version "20261002-115811"
  license "Apache-2.0"
  head "https://github.com/raspberrypi/usbboot.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(\d{8}-\d{6})$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "89bc8eed4f37b8c53abb40f5370b7208ca1ce1c476df085254277a82e78fcf62"
    sha256 arm64_tahoe:       "f63b5f67eecfe7d4bc7c24052705f456fe23a541722dfd5fac92d99fdb091727"
    sha256 arm64_sequoia:     "9c5ed03e24b2fa0d6c3b05d021ff4f67ed245b42af97f95db8b730ccbb868449"
    sha256 arm64_linux:       "8f4f810d4a22ac53ab9a5e9188b847b848ab036422817b3c3e2e90ccb413c157"
    sha256 x86_64_linux:      "af46bd06e72ddc7794bae9a763b7a964a5947dc3d14218e2cbfa572add605761"
  end

  depends_on "pkgconf" => :build
  depends_on "libusb"

  uses_from_macos "vim" => :build # for xxd

  deny_network_access!

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
