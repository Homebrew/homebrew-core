class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-1.7.0.tar.gz"
  sha256 "b428527e4031453a637128077983e782e9fea25df98e95e0fc27819b2e82fd7f"

  bottle do
    cellar :any
    sha256 "552a7af3bb8af3cd9f90a63a3750b8237f332692aebc057e92e3ee3925b1c41e" => :mojave
    sha256 "3a3f3496aae167289310bcd24f3ce355dc20464bc676269925f2898378a1fa8e" => :high_sierra
    sha256 "05935fa33b0103d8ff2909693f4476283cf2be49e2864b78caea85cc59cbae32" => :sierra
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

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
