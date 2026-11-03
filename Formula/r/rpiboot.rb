class Rpiboot < Formula
  desc "Raspberry Pi USB boot tool for Compute Modules"
  homepage "https://github.com/raspberrypi/usbboot"
  url "https://github.com/raspberrypi/usbboot.git",
      tag:      "20261103-150646",
      revision: "8639e9da26db78fab8c53058e10b0ff1bf253483"
  version "20261103-150646"
  license "Apache-2.0"
  head "https://github.com/raspberrypi/usbboot.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(\d{8}-\d{6})$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "eb13356c2c0b6ffc0c598b4c5c56330925ce88f3389aaffef2994de01e7e1864"
    sha256 arm64_tahoe:       "8e4cbde8e831ae6cd56841b54bddb883b62b5395e2c81b11c7da3a4be72324a0"
    sha256 arm64_sequoia:     "2cbdc1bcdb5fb137a8ad04b0df3a1212136e764ebcd15191e4f9006033d8803c"
    sha256 arm64_linux:       "f3bc942d4fcb388a8d90e594d10c5ca447f9668ce146d899cf305a16f65a9113"
    sha256 x86_64_linux:      "3df21f052fb82a1eb3fccdcbfdd5946cb9e8f3e5824e9f9a7f3954f5f03d1585"
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
