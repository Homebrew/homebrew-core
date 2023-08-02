# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/legacy-homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.4.4.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.4.4.tar.gz"
  mirror "https://archive.org/download/xz-5.4.4/xz-5.4.4.tar.gz"
  mirror "http://archive.org/download/xz-5.4.4/xz-5.4.4.tar.gz"
  sha256 "aae39544e254cfd27e942d35a048d592959bd7a79f9a624afb0498bb5613bdf8"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  bottle do
    sha256 cellar: :any, arm64_ventura:  "179cc5316bed5c452aa1658a2a100bc8cd1b210d79c0f2fffec4934fd1f4cd8a"
    sha256 cellar: :any, arm64_monterey: "c3ad39578242f6fbb2759e6acbcbb5af3b6aef6f77c6ed230ae3a83626353202"
    sha256 cellar: :any, arm64_big_sur:  "f9d3283059582bf3eec0af86d8910e8409b0e1b092b7f018a9e7d6773f9ac4e4"
    sha256 cellar: :any, ventura:        "b9aebe3c04f5f17837a43f68ee0c276698b9a8dfad3aa4520f79f802f4f8832e"
    sha256 cellar: :any, monterey:       "1197fc939b8c9722ad7b36d8b38ddee54531f03d2f9f1c33f5ca91e843b13e62"
    sha256 cellar: :any, big_sur:        "cc402684eb7e9e81ea12b8721078c8fa1d36f2edd7ce41d0835282c00197fb0b"
    sha256               x86_64_linux:   "91c390f663972a9249fbbd98546bc2687afab99e5c740065d33cb474ed612bf5"
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

    # Check that http mirror works
    xz_tar = testpath/"xz.tar.gz"
    stable.mirrors.each do |mirror|
      next if mirror.start_with?("https")

      xz_tar.unlink if xz_tar.exist?
      system "curl", "--location", mirror, "--output", xz_tar
      assert_equal stable.checksum.hexdigest, xz_tar.sha256
    end
  end
end
