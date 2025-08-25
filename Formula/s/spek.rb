class Spek < Formula
  desc "Acoustic spectrum analyser"
  homepage "https://www.spek.cc"
  url "https://github.com/alexkay/spek/releases/download/v0.8.5/spek-0.8.5.tar.xz"
  sha256 "1bccf85a14a01af8f2f30476cbad004e8bf6031f500e562bbe5bbd1e5eb16c59"
  license "GPL-3.0-or-later"
  revision 5

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f40b4ee20bca33002967ae29fe5384a5afbc2781803b808689b2d5d1763c5677"
    sha256 cellar: :any,                 arm64_sonoma:  "80991117eb88ee56dc4af9364593b9330acfd3c2acf7c5a3e6abdcd5ef528111"
    sha256 cellar: :any,                 arm64_ventura: "01d7ad7f6b5bb9dd41ab69b17b2524960efce8ab5caee33002c0301fa224b1e5"
    sha256 cellar: :any,                 sonoma:        "f47955e144d8d2b2eee7365d53d83b6b8b1a930e6ec8ed6b7a395c09a8207991"
    sha256 cellar: :any,                 ventura:       "aaecdb8a002833b629061b2b170c08111ff6c2ddcec636f83a7a804fcbed6996"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53b6b1a34a1709059ac3bce1c1657c117c8fc169b6635d8c665005f503195771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fa1682551517aeaa63915ec2dafafcb7a9a738779d24f503949ee1f1406dc5e"
  end

  depends_on "pkgconf" => :build
  depends_on "ffmpeg@7"
  depends_on "wxwidgets"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"

    # https://github.com/alexkay/spek/issues/235
    cp "data/spek.desktop.in", "data/spek.desktop" if OS.linux?

    system "make", "install"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Spek version #{version}", shell_output("#{bin}/spek --version")
  end
end
