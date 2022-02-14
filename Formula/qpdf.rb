class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.6.1/qpdf-10.6.1.tar.gz"
  sha256 "4c56328e1eeedea3d87eb79e1fe09374a923fe28756f7a56bcff58523617f05f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aa0ba418a528f636469bcdf305a77dd88f89026a6e6e123a98eee0c84cede879"
    sha256 cellar: :any,                 arm64_big_sur:  "f629f8f3aea95e5a3b2e52af7e989f57fd09183424ed9095febc38b0c25b49aa"
    sha256 cellar: :any,                 monterey:       "aa5db4a61ad465bde40d0939acb6b086e74e636eb422ce5f50ef23ea7bb63138"
    sha256 cellar: :any,                 big_sur:        "ca43e4b70db69d92c8b4fa6952ac944f33f205542c68de3dfea1fc96974b3aac"
    sha256 cellar: :any,                 catalina:       "07c23b2aaaecb7926f44b082ceb1055731c91a0dc735f35e3f320fb879593e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce469c051067588983229dcf201e1491419c63738f2c99ddeaf5682abf18372e"
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
