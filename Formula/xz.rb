# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/legacy-homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.2.6.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.2.6.tar.gz"
  mirror "https://archive.org/download/xz-5.2.6/xz-5.2.6.tar.gz"
  mirror "http://archive.org/download/xz-5.2.6/xz-5.2.6.tar.gz"
  sha256 "a2105abee17bcd2ebd15ced31b4f5eda6e17efd6b10f921a01cda4a44c91b3a0"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  bottle do
    sha256 cellar: :any, arm64_monterey: "b2f0ff235854d96ba7e8ffce77bb21e0d1d179aca9ffdb8f7233b2d57e96b8dd"
    sha256 cellar: :any, arm64_big_sur:  "3441afab81c2f9ee9c82cac926edcf77be0bca61664c6acedfaba79774742ac2"
    sha256 cellar: :any, monterey:       "c9f660a47ce332f3db7401bb830d5129c29e5759fd09f7a23989b873c807a319"
    sha256 cellar: :any, big_sur:        "a61f86356450826377490cf6b22e867a423ba88dd3a1dc91792a7cbf57fcac84"
    sha256 cellar: :any, catalina:       "efcb62b10858d4f3ca16e9409eff9f93ac0ff7adee546d21f4638dae20d89300"
    sha256               x86_64_linux:   "5308bba4329d4ca980f8a2a8cb6b26e746f498e5dc76cc32b02ff97a7a61a49c"
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
