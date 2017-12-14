class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey NEO PIV applet"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-1.5.0.tar.gz"
  sha256 "c18375179ba25bf9d61365b3903f033f112897bbd54ca63c62fa153f2d05aaab"

  bottle do
    cellar :any
    sha256 "ec76783c66fbc2c185ed65cf9f429907bce346826225df40856a22a75f1088dd" => :high_sierra
    sha256 "7fd7da3692b310b237002846bb9de30e1c76fc60662083b2fcbc54bf5c19ec6a" => :sierra
    sha256 "d47f85177b7db7c4a47552c01d1b4b2ceb312b701f521264a039e9f65b36e5fe" => :el_capitan
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
