# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.2.5.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.2.5.tar.gz"
  sha256 "f6f4910fd033078738bd82bfba4f49219d03b17eb0794eb91efbae419f4aba10"

  bottle do
    cellar :any
    sha256 "5aa90b77d5e772dacd38146bbb7ff2fa43f210e3779def2c0f16cbdae8589aa3" => :catalina
    sha256 "010667293df282c8bceede3bcd36953dd57c56cef608d09a5b50694ab7d4b96b" => :mojave
    sha256 "e7be50f4ee00e35887f3957263334eb3baba59e8c061919060f9259351be6880" => :high_sierra
    sha256 "bcc71ee69e2c43bf56b9c9ece5a53dc3439652f355620a25b020f794cd447fb7" => :sierra
    sha256 "974aae83ba7ceb62040c5bf02b1fb277a919212714c8da2a4c5eb3d1d119a465" => :el_capitan
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
