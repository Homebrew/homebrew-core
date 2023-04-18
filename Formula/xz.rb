# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/legacy-homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.4.2.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.4.2.tar.gz"
  mirror "https://archive.org/download/xz-5.4.2/xz-5.4.2.tar.gz"
  mirror "http://archive.org/download/xz-5.4.2/xz-5.4.2.tar.gz"
  sha256 "87947679abcf77cc509d8d1b474218fd16b72281e2797360e909deaee1ac9d05"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  bottle do
    sha256 cellar: :any, arm64_ventura:  "5919a39bb56458a164ec5b757b0cb903c2d167e4e593daf8360a55db1db85d4f"
    sha256 cellar: :any, arm64_monterey: "5845749ecdee7fd6fbf5553815b58d23e693b43e8b07ac5c49814015e4d1b4b8"
    sha256 cellar: :any, arm64_big_sur:  "dba846beae52b51824208b63a543b991abdaa51fb13db53df5bb928e649f53ea"
    sha256 cellar: :any, ventura:        "3ab65841cb683e7a8505523ef097358d43a93de337d4512229be9d1caf82b209"
    sha256 cellar: :any, monterey:       "e374ae9bec525b5811432f833cd09f6cd29f3299e1b0927d6d3cac04938176d1"
    sha256 cellar: :any, big_sur:        "0a770d2abc48a2478650c76648d540e9bf3b964804959ee4abbfc70bd46ef24c"
    sha256               x86_64_linux:   "a51b96480a40a3eac596b82a4c1d899a53dcc653bca4066332db2698ea596f7a"
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
