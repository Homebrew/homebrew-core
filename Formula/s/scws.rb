class Scws < Formula
  desc "Simple Chinese Word Segmentation"
  homepage "https://github.com/hightman/scws"
  url "http://www.xunsearch.com/scws/down/scws-1.2.3.tar.bz2"
  sha256 "60d50ac3dc42cff3c0b16cb1cfee47d8cb8c8baa142a58bc62854477b81f1af5"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "bb7b68fb9fcbf51ad8170b10e1e25c4674c99bc1e99870446659c5dcc2f0b5ba"
    sha256 cellar: :any,                 arm64_sequoia:  "294a02ffae27e71589019a49e8031b89e2af74a54603e3caa1a60ffd5fa91e17"
    sha256 cellar: :any,                 arm64_sonoma:   "97322bf31231434433412e95b1561a5aa7ed1bc0887f5178a46533063295ff51"
    sha256 cellar: :any,                 arm64_ventura:  "6cdacaab4cd3ed03a55566db445ac6dc331bb653a15fa5c1927e829e91a3a8c4"
    sha256 cellar: :any,                 arm64_monterey: "fe10618f55a2c8275a3e072f9bce64662007c4cb3f5785bf704c92f7f2b43845"
    sha256 cellar: :any,                 arm64_big_sur:  "ac7b0ac31fb12e9c1e4611e00dc70e5a5a4eedec4cc3d700826937eb4f67f5a6"
    sha256 cellar: :any,                 sonoma:         "2544902ff66d5a1f98ffed9720d2fee60ed89a06399fbc9108b5b9862600dcab"
    sha256 cellar: :any,                 ventura:        "c03c054ab769c6deb805ca79b72620f73aa4d364b2c549f6d390b89128951e11"
    sha256 cellar: :any,                 monterey:       "27a90e1636343c3ba08280f7717cca86405e82efca0e0b6660ea5c850de8b38e"
    sha256 cellar: :any,                 big_sur:        "6d87c6c7431b97511b7ce3ec42493bff7685c6ee2682d9733428a71826a8b300"
    sha256 cellar: :any,                 catalina:       "4dedb954c6d17b1cc42d41a978e41a897110e042bbd6099f82bdbd0ff86b7aad"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "760697469c3bd5b9d57792dafe9b130f751f56a727f743700070b0cc95fac108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "146dd8b73ef91bcb9118130d13e30803b4213eddeda7d80b5f2a5d75e83f7c64"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/scws -c utf8 -i 人之初")
    assert_match "人 之 初", output
  end
end
