class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-1.7.0.tar.gz"
  sha256 "b428527e4031453a637128077983e782e9fea25df98e95e0fc27819b2e82fd7f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3f2eed436a541be3d2237fbd67c46c80187b70e20ec025e5d218765486f57ac3" => :mojave
    sha256 "bb089bf8da6abf4c048c2173039d7587df31437eb01d52ac9f254286fe38ec9a" => :high_sierra
    sha256 "7af412bcd780062bb35eae49852dd16bb46cae272543e0a0f3375d3380fd52b4" => :sierra
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
