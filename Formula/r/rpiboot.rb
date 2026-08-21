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

  bottle do
    sha256 arm64_tahoe:   "31cb9beee0a7ec2286049723c054e8db04f54adbad073b51566ec967bda97149"
    sha256 arm64_sequoia: "f7a90ea74346f3e711f948d047edf2e2cd824f85e8ca0b4c7a7097d863942779"
    sha256 arm64_sonoma:  "c66e0d7c224d8a185dbec4b96b2a54971d9c4d3acc5ccfce9d7e057bae0463c0"
    sha256 sonoma:        "beca79fd2907f5c3a5a220d19d729d501c8ebaf3e61d4ad3939ebe903399d481"
    sha256 arm64_linux:   "d46d84f2dca76f09f8a12511e76625f8c8a20e27301300b0432b7c1dd90b68d2"
    sha256 x86_64_linux:  "2523c3dbff24ee0d324180c581a9b57ba8d718da4cbcc385fe536d898bc06a86"
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
