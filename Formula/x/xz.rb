# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/legacy-homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.4.6.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.4.6.tar.gz"
  mirror "https://archive.org/download/xz-5.4.6/xz-5.4.6.tar.gz"
  mirror "http://archive.org/download/xz-5.4.6/xz-5.4.6.tar.gz"
  sha256 "aeba3e03bf8140ddedf62a0a367158340520f6b384f75ca6045ccc6c0d43fd5c"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "ea718d075502d4457709da89e8e424aa22cfa19d2e16088c43feb87f7c2c477a"
    sha256 cellar: :any, arm64_ventura:  "05d853bc61d9bf9ed3ca2e5e54bc240f1924fb9085618387f7f6ce90b25b1d95"
    sha256 cellar: :any, arm64_monterey: "9fc86674518bc901632194b94e0b23aa82f4dc73129da950deb1f385ac567da5"
    sha256 cellar: :any, sonoma:         "bdd5146737d8a84b8a855d7b1bdc81cd2d20692c5d77810fa7472cd9bb41fb47"
    sha256 cellar: :any, ventura:        "cb65d2fa8ede8c24d7556003079fb13c0324d68efc7421dda74d57cb5d34c483"
    sha256 cellar: :any, monterey:       "5deb5724177bbe7c4824e0281fd1713ae0eb32abaede2ee29b35be4afc1a6c47"
    sha256               x86_64_linux:   "50675435a60d1190dbea52c5dbd65e70c7bd430e4de7472dc57901222ca11fb7"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
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
