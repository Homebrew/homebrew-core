class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.6.2/qpdf-10.6.2.tar.gz"
  sha256 "4b8c966300fcef32352f6576b7ef40167e080e43fe8954b12ef80b49a7e5307f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "365dc91f990f83a7a63116ebf3d58766555752d546632e8ad65a1380f7509c11"
    sha256 cellar: :any,                 arm64_big_sur:  "a2cab776d352e83a86ed526a0051d6e16e3fd83a42f41010b0fa9b27e74e9fe2"
    sha256 cellar: :any,                 monterey:       "adb76f57bcacbd8b7322f0f0e79c6cb8922a17f51ada9bfb7d35672600e239b0"
    sha256 cellar: :any,                 big_sur:        "b96113b17f4689a64be5b5a0ca84e18d661d45fe37bcba77c5154a6886f41b0b"
    sha256 cellar: :any,                 catalina:       "386fc704b7021d7a0ae74d0cd4dcefc33f95eac036db9eaba696516a6dd5646f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b283b7eb55707a42ad6e290f6be454d489d4f11ac01996773e7d961c355ad2e"
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
