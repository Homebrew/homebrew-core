class Xaric < Formula
  desc "IRC client"
  homepage "https://xaric.org/"
  url "https://xaric.org/software/xaric/releases/xaric-0.13.7.tar.gz"
  sha256 "fd8cd677e2403e44ff525eac7c239cd8d64b7448aaf56a1272d1b0c53df1140c"

  bottle do
    rebuild 2
    sha256 "b916b4f80429db2d487478f6bc9c53de07ea4bd23ada7f0deeb8f2a3fb7f1e1a" => :catalina
    sha256 "31cc50542222e8ceae4b46887441fdd73be022bab481cfa205d2aae558c0d95b" => :mojave
    sha256 "ba6e8b473868db28ea7d83417f1b4a5b4ccc6ed5b126653da6b1a3407d4b54fc" => :high_sierra
    sha256 "7a4074ad4ca9ed3950fb4badb76ae4ec9a7c9228fd65a7a4d7d8b89296af8d3b" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match(/Xaric #{version}/, shell_output("script -q /dev/null xaric -v"))
  end
end
