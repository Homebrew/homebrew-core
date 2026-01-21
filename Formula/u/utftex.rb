class Utftex < Formula
  desc "Pretty print math in monospace fonts, using a TeX-like syntax"
  homepage "https://github.com/bartp5/libtexprintf"
  url "https://github.com/bartp5/libtexprintf/archive/refs/tags/v1.28.tar.gz"
  sha256 "9db41a6d59ab20d55936a825b0fdd5ad0168599eca16ea7a2a11218a0c140798"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d034f23babf992ee2eac7ab994c72be940354498015c88597f2b6a82bfe2f8a"
    sha256 cellar: :any,                 arm64_sequoia: "609bd90c8adae4a948aca166f3624daa8407404c6959427224b90be54185dbe0"
    sha256 cellar: :any,                 arm64_sonoma:  "e6dc4264e5a27545d328f30800b285222c22a9b32b42797453de14988617359b"
    sha256 cellar: :any,                 sonoma:        "3e07289f95664623ee186e015c4a660097161f6fa92f44989a27903fd7400bc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9a4dd8c616bcfe728ef03fe4526da7f1b800a7315c73c0ecdbc6ec4d34f5748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06207925105da3d4c3b3118f685c0e5e7e96996bcc627864d14e79aa032a6215"
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
