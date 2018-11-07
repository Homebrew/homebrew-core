class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-1.6.2.tar.gz"
  sha256 "ea61bcd5c75471ed21903967d0121fb090aa4d325ec279a24633e3235fdf231b"

  bottle do
    cellar :any
    sha256 "6acce9035255fc4cc53f517709704c3300a1f0052bba2d96416b9dfc70c5cbc6" => :mojave
    sha256 "4d8f95198ef3fcd9b8f20ec251f74ebac64c7b1c5306e33c4d09750fe0fe67b1" => :high_sierra
    sha256 "8a687ec5093815f876df56284c463d32f33d3950f41e81c36c3d1a1d98570e91" => :sierra
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
