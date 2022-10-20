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
    sha256 cellar: :any, arm64_monterey: "b3e7a5b4f97b75c5c00915acaa4f2a2bad2349e481cdf943c88caf2f9dbc8776"
    sha256 cellar: :any, arm64_big_sur:  "25f809e0aebb715870b36acfa6ef04be488b0b351521cb7a372c26c28363ea4e"
    sha256 cellar: :any, monterey:       "02ed422191f81ca5c476f82264b6662a1ebcf95b90fb3ee10b52462cccdc55a8"
    sha256 cellar: :any, big_sur:        "caab4b755676f1dd4dd3e84da8ad0e86a302768d53af9bbe75dc9b72413e29a9"
    sha256 cellar: :any, catalina:       "769a180d3e9ea3d792f9cb166a4439a9d6f08154a38cd47cc43e08390d50f2f1"
    sha256               x86_64_linux:   "dda25f66145c180884d0550a36d68491abd648011b9ac91566773961a1d921aa"
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
