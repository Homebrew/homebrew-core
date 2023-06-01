class Sonixflasher < Formula
  desc "CLI-based Flasher for Sonix 24x/26x MCUs"
  homepage "https://github.com/SonixQMK/SonixFlasherC"
  url "https://github.com/SonixQMK/SonixFlasherC/archive/refs/tags/1.1.0.tar.gz"
  sha256 "899beef48ca8eca0d8037794870f9f58f7cb463e3a3ddfeb2b5c446edbffbef9"
  license "GPL-3.0-only"

  depends_on "pkg-config" => :build
  depends_on "hidapi"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
  end

  def install
    system "make", "clean", "sonixflasher"
    bin.install "sonixflasher"
  end

  test do
    output = shell_output("#{bin}/sonixflasher -V 2>&1", 1)
    assert_match "sonixflasher 1.1.0\n", output
  end
end
