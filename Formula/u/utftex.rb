class Utftex < Formula
  desc "Pretty print math in monospace fonts, using a TeX-like syntax"
  homepage "https://github.com/bartp5/libtexprintf"
  url "https://github.com/bartp5/libtexprintf/archive/refs/tags/v1.30.tar.gz"
  sha256 "57803b14825a5fcaf7a0a357cf7fd00169262b351023661e40eb7c496a15e2d4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f45ab1902d0571453123de0675f47f45d5d2bb29c3dac5b542ea9846479e5a8b"
    sha256 cellar: :any,                 arm64_sequoia: "d97fee43b1edafdf9cfd9b0238ae8d100993aa63b434a4be0e3477b5e395cabb"
    sha256 cellar: :any,                 arm64_sonoma:  "a4220ffcedb7b9caf570b833b77ae9430ed8564f1dd7f89b10374b28ea7b7813"
    sha256 cellar: :any,                 sonoma:        "396d5a9bcca537675cf15ba6813eb5481feff4064d9d83c6e1ee3315649fe787"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cba5a920c2169029ff3c7192e1b19a51e85112c5558e36f66925a05ace6fda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "540c5aaf70bff8d2862f2a18d5b78bb290f8f8924b7d4db20020846a0de3cf80"
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
