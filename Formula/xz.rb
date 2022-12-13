# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/legacy-homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.4.0.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.4.0.tar.gz"
  mirror "https://archive.org/download/xz-5.4.0/xz-5.4.0.tar.gz"
  mirror "http://archive.org/download/xz-5.4.0/xz-5.4.0.tar.gz"
  sha256 "7471ef5991f690268a8f2be019acec2e0564b7b233ca40035f339fe9a07f830b"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  bottle do
    sha256 cellar: :any, arm64_ventura:  "0e1e7449fcebf84c49d5dd42a61c78c4585ce0f454ff18f77d000270d1551ecc"
    sha256 cellar: :any, arm64_monterey: "2efce74f1dc3366cb8cadd25ecc1a1f99e87890202b87980219589d900eb6b73"
    sha256 cellar: :any, arm64_big_sur:  "59be4a80fd5117cb4d092aa28e94fe115371a0ef01f2982cff26ea3c4f40ad9b"
    sha256 cellar: :any, ventura:        "51ee881af7804b4626c0cc93829ae531dc988598d37d20b7e8e81fcc1dcf3ebf"
    sha256 cellar: :any, monterey:       "0ad360d7faae284e54fd50c09a86871ff65be56f78537386d3d97b1df9db34b8"
    sha256 cellar: :any, big_sur:        "140a76ac3398be50b9b98448edc8d8b5f8f1a115918eb4f1382821323f2d2d08"
    sha256               x86_64_linux:   "b72d0b9d438157bbd511f3d77f23d3d4c2657451ac1d8e665765b4a41d5c5f63"
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
