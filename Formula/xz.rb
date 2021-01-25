# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.2.5.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.2.5.tar.gz"
  sha256 "f6f4910fd033078738bd82bfba4f49219d03b17eb0794eb91efbae419f4aba10"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "4fbd4a9e3eb49c27e83bd125b0e76d386c0e12ae1139d4dc9e31841fb8880a35" => :big_sur
    sha256 "c84206005787304416ed81094bd3a0cdd2ae8eb62649db5a3a44fa14b276d09f" => :arm64_big_sur
    sha256 "2dcc8e0121c934d1e34ffdb37fcd70f0f7b5c2f4755f2f7cbcf360e9e54cb43b" => :catalina
    sha256 "44483961b5d2b535b0ece1936c9d40b4bc7d9c7281646cca0fb476291ab9d4dc" => :mojave
    sha256 "1491b2b20c40c3cb0b990f520768d7e876e4ab4a7dc1da9994d0150da34ba5c6" => :high_sierra
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
