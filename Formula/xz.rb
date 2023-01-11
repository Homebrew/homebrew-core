# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/legacy-homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.4.1.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.4.1.tar.gz"
  mirror "https://archive.org/download/xz-5.4.1/xz-5.4.1.tar.gz"
  mirror "http://archive.org/download/xz-5.4.1/xz-5.4.1.tar.gz"
  sha256 "e4b0f81582efa155ccf27bb88275254a429d44968e488fc94b806f2a61cd3e22"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  bottle do
    sha256 cellar: :any, arm64_ventura:  "e828eeea6fa5459a58f01d73cd0650799335f8319c686dd91f6a194eb224bf38"
    sha256 cellar: :any, arm64_monterey: "1872953eda5b6724d90376a449d18745e5daf8ebe760f02c2f7a4236847176fc"
    sha256 cellar: :any, arm64_big_sur:  "6ff9bd9132ef3611fc191dfc5f19a4df52632f0e8848f2e0bf18c3ec09f882a6"
    sha256 cellar: :any, ventura:        "13908e0a3e7e4203a5805536fbea3efef80fa1ee2c2fee88b4b6dd50ea564588"
    sha256 cellar: :any, monterey:       "49097bc9869e9ab546ae8ae84bd9df6267c935ecf8c1f87422fe9da4cb37b0a4"
    sha256 cellar: :any, big_sur:        "a142a10402ae243db22f3eb3ba506532536f0118ea8df9dc3ede8a31a5a6b107"
    sha256               x86_64_linux:   "ce4daa84cc24f38a0e1c76646b83374ac210f094aefbf4db4d627c4c324e9c60"
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
