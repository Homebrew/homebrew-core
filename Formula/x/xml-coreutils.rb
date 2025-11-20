class XmlCoreutils < Formula
  desc "Powerful interactive system for text processing"
  homepage "https://xml-coreutils.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xml-coreutils/xml-coreutils-0.8.1.tar.gz"
  sha256 "7fb26d57bb17fa770452ccd33caf288deee1d757a0e0a484b90c109610d1b7df"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "22c2ae517628eda8490bcd905104f86b4007e93617ba053f985fcfe54af1aebc"
    sha256 cellar: :any,                 arm64_sequoia:  "f0416be37c963bcfec7ccdab87e91272d03f68a314ceda3b287f154397e9481c"
    sha256 cellar: :any,                 arm64_sonoma:   "790f661b91e380a378cd57afab0a102398fd23bb51f08cd793bdcb8a84806716"
    sha256 cellar: :any,                 arm64_ventura:  "0074dde2a0a868040ad32a09cba6947f7e27e0b69dcf95c9f05a478764e3a858"
    sha256 cellar: :any,                 arm64_monterey: "27121488a3c491191c025a484e1f76d0ad162f19ba6cddf733a5826cdddf05a9"
    sha256 cellar: :any,                 arm64_big_sur:  "7094a5673f2ab6ba2fa45c587397650f4d9b2ccea1ab66925f58ef776683298d"
    sha256 cellar: :any,                 sonoma:         "156febc90b868053572dc3f5899c058603b05ec857253bfb1e20911fe753f3a7"
    sha256 cellar: :any,                 ventura:        "9a121bba70de700e46049e302ce80bb9ae45ffda8f1007cabbc0169b6e2c085a"
    sha256 cellar: :any,                 monterey:       "80d3c4547a1f1a152c3f37477430b6d1628cba725ac191d28f4c024cf064dcfa"
    sha256 cellar: :any,                 big_sur:        "6e5400968229c313cab973cffdbb77b88c30a5301066626b34b96e0a46578fc8"
    sha256 cellar: :any,                 catalina:       "e098f5b2d9af801bb12c65044668091b175dcca43cec7251acb0d3e1ccad4fed"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2af316536161edd2476615f846b91b467e30f0bc5abcec74f0f71516b3c79202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e62450955a07231a3334f3972e3ea93e622ca55c54ca3e0eae04db5df6d8fc69"
  end

  depends_on "s-lang"

  uses_from_macos "expat"
  uses_from_macos "ncurses"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.xml").write <<~XML
      <hello>world!</hello>
    XML
    assert_match(/0\s+1\s+1/, shell_output("#{bin}/xml-wc test.xml"))
  end
end
