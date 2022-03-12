class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.6.3/qpdf-10.6.3.tar.gz"
  sha256 "e8fc23b2a584ea68c963a897515d3eb3129186741dd19d13c86d31fa33493811"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b4bc03f5c24a4305261aaf31841f3588d08c4c9317712bcdd948b278a3bf14eb"
    sha256 cellar: :any,                 arm64_big_sur:  "042f245db23934629bb538746ab287dd1cb4d096f16289f8068d07b98e9aa0c4"
    sha256 cellar: :any,                 monterey:       "610f410788d9c34ea2c8a8af2f8935627305b2a3fc148969f7f7ca173e1ac6f6"
    sha256 cellar: :any,                 big_sur:        "c7578fc7da02522ec78ed8df30abb0a3521a7bd9880320ed45750451055681b4"
    sha256 cellar: :any,                 catalina:       "c206dcde8ac57e2a0c7c7cd1323972cee8cb536467051f600026d315bcaca9f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a076d5c24158183d68030ae051991b2fdf348f32896ad1da739d1c79ad98c84"
  end

  depends_on "jpeg"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
