# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.2.5.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.2.5.tar.gz"
  sha256 "f6f4910fd033078738bd82bfba4f49219d03b17eb0794eb91efbae419f4aba10"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  bottle do
    sha256 cellar: :any, arm64_monterey: "fcda3e81efe284f7e07effcb4ba03a87c8d828833351ac3f41e1e808e7753b0a"
    sha256 cellar: :any, arm64_big_sur:  "c84206005787304416ed81094bd3a0cdd2ae8eb62649db5a3a44fa14b276d09f"
    sha256 cellar: :any, monterey:       "099055bb0afb3dfd454e72ce2228a0fad54e90ef63577e33d18b9c92a444317a"
    sha256 cellar: :any, big_sur:        "4fbd4a9e3eb49c27e83bd125b0e76d386c0e12ae1139d4dc9e31841fb8880a35"
    sha256 cellar: :any, catalina:       "2dcc8e0121c934d1e34ffdb37fcd70f0f7b5c2f4755f2f7cbcf360e9e54cb43b"
    sha256 cellar: :any, mojave:         "44483961b5d2b535b0ece1936c9d40b4bc7d9c7281646cca0fb476291ab9d4dc"
    sha256 cellar: :any, high_sierra:    "1491b2b20c40c3cb0b990f520768d7e876e4ab4a7dc1da9994d0150da34ba5c6"
    sha256               x86_64_linux:   "c94b4200b32d1e4e917f3b502eafc39579a84533ef6b6a0d58469fa845511612"
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
