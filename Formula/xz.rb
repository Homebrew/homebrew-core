# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/legacy-homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.2.7.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.2.7.tar.gz"
  mirror "https://archive.org/download/xz-5.2.7/xz-5.2.7.tar.gz"
  mirror "http://archive.org/download/xz-5.2.7/xz-5.2.7.tar.gz"
  sha256 "06327c2ddc81e126a6d9a78b0be5014b976a2c0832f492dcfc4755d7facf6d33"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  bottle do
    sha256 cellar: :any, arm64_monterey: "345b942fb105c850d6243d91502fa285408cfcc7d78d9aaf27322acea608e901"
    sha256 cellar: :any, arm64_big_sur:  "08ae5dd072653e49b921bc68ed69cbd36581f32fa12d49658e9481f55990a88d"
    sha256 cellar: :any, monterey:       "853c17e5062001c0bf5d59875b7fcda3610438747680187586f96db93395fc11"
    sha256 cellar: :any, big_sur:        "e2d22d68de9a20e44053eb9dbcc64a6a0beb5ab33b6d6653b4fea0e42342a948"
    sha256 cellar: :any, catalina:       "2cc7627ad8dedb17a04f341b2a43e1307f7bd4f1516d344ca52547ec732ae305"
    sha256               x86_64_linux:   "607a3d993f45efe858d3e4f002603e323a1b1f0c87b4db6fb57d1280f479809d"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.xz
    system bin/"xz", path
    refute_predicate path, :exist?

    # decompress: data.txt.xz -> data.txt
    system bin/"xz", "-d", "#{path}.xz"
    assert_equal original_contents, path.read
  end
end
