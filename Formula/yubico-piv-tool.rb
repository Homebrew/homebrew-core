class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-1.7.0.tar.gz"
  sha256 "b428527e4031453a637128077983e782e9fea25df98e95e0fc27819b2e82fd7f"

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
