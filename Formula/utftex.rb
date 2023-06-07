class Utftex < Formula
  desc "Pretty print math in monospace fonts, using a TeX-like syntax"
  homepage "https://github.com/bartp5/libtexprintf"
  url "https://github.com/bartp5/libtexprintf/archive/refs/tags/v1.21.tar.gz"
  sha256 "8089e77257d1686d7cdd72c390288615def720619bea2db4408c2659f993562d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f82c51a29753666beb91009df42ba0abcbda4fb3cff19415e79c4cb6ef807770"
    sha256 cellar: :any,                 arm64_monterey: "8554b290f634b0b9a55f25cf202f1d1d261ff40fe3f9b4973050aea74cf4d3bb"
    sha256 cellar: :any,                 arm64_big_sur:  "6becfa946ecc1a87471adba47cb940ee866097ae0ced51bf906f0ae42319da1b"
    sha256 cellar: :any,                 ventura:        "91a55d196421bcc355b7f2d566c3e2b895c096ab24a9ffa47f38cb16738e065c"
    sha256 cellar: :any,                 monterey:       "e9e62ff4e698548256fd9d03595565398e4b98136e9cf06caa6ed5cbbbed013d"
    sha256 cellar: :any,                 big_sur:        "489ec075341f2c9563098adc762b651dd17906b17b543c3cc3a7805f8d14f2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edcbad8d8b39072f85fd33bbc2e4d77434cebd848f0c2e1fc57a0047640b6886"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"utftex", "\\left(\\frac{hello}{world}\\right)"
  end
end
