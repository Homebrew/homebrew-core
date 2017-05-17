# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  url "https://fossies.org/linux/misc/xz-5.2.3.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.2.3.tar.gz"
  sha256 "71928b357d0a09a12a4b4c5fafca8c31c19b0e7d3b8ebb19622e96f26dbf28cb"

  bottle do
    cellar :any
    sha256 "2518e5105c2b290755cda0fd5cd7f71eea4cd4741b70c48250eed1750c3a6814" => :sierra
    sha256 "faa0f79c1776a8b5d8093f84fca4c92e1ada51957a1381d120f690be36b42819" => :el_capitan
    sha256 "82eef73a78db1c46ed8482c357f6ad1797a62f4c9124410b362efe885082892c" => :yosemite
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
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
    assert !path.exist?

    # decompress: data.txt.xz -> data.txt
    system bin/"xz", "-d", "#{path}.xz"
    assert_equal original_contents, path.read
  end
end
