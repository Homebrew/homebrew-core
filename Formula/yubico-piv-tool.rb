class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey NEO PIV applet"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-1.6.1.tar.gz"
  sha256 "91c3f575b59e52fa90e50342e5accbe7f71e9196cbe2ad6b9f5fef1e0a6baf83"

  bottle do
    cellar :any
    sha256 "7d4062cf3aae4444e599b5a6ff2fccbdd1fb27e254a912a3cb9826d7bb82beb1" => :high_sierra
    sha256 "7ea8049034bb54c27226492a5948417ea6f21984e8272d4696456d7a43565b1c" => :sierra
    sha256 "02b0f5330bec47807df4639a354a41523ff7d4d97d1bcc352f6b66415bc1249c" => :el_capitan
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
