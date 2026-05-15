class Utftex < Formula
  desc "Pretty print math in monospace fonts, using a TeX-like syntax"
  homepage "https://github.com/bartp5/libtexprintf"
  url "https://github.com/bartp5/libtexprintf/archive/refs/tags/v1.31.tar.gz"
  sha256 "265b15619c287119a73269a0d309587f697960867d01827e769826bf86a12216"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a323b3b8def5c96c03e8ba1a158b38a636088317d9630f5978b7dec3a2a7b212"
    sha256 cellar: :any,                 arm64_sequoia: "53240cfcf74836902e57d90eae41cdf8d47709b4c66d07676cdde2ac3c63da0c"
    sha256 cellar: :any,                 arm64_sonoma:  "17ebd4a3d357197efcb58c44bc0b1a4595f453dd7b51616c41c680055cd2e938"
    sha256 cellar: :any,                 sonoma:        "79913315c9d2ec3c2d3ac57d2ea7f395839278f7b8ce1c48181ea55b19704ba4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "144a0233f593829f428859642ed231bdf300378afdccf48c7a5887f5a9b23769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "733b373d361275776ee9e70d15b02336adb869b19401d4b700545000b144b3a0"
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
