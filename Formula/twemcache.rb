class Twemcache < Formula
  desc "Twitter fork of memcached"
  homepage "https://github.com/twitter/twemcache"
  url "https://github.com/twitter/twemcache/archive/v2.6.3.tar.gz"
  sha256 "ab05927f7d930b7935790450172187afedca742ee7963d5db1e62164e7f4c92b"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/twitter/twemcache.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9fc117b9ed7036aa0a69fb94ee4c66e768f663bfd41cf4e626839f003ed5b9cd"
    sha256 cellar: :any,                 big_sur:       "125878f0cdb71a5ac116ddcdfc139fd43d8ca2415e450c78bb25ff20cf65132e"
    sha256 cellar: :any,                 catalina:      "64238f0d8c99fad48b6d3f780f2e42557caa316e807a3a411fbeab3a649fc0c3"
    sha256 cellar: :any,                 mojave:        "2c7fd2ce03cc16859264882f478137de35ece42a26ad9b10f23d668ddc1883d4"
    sha256 cellar: :any,                 high_sierra:   "9cc173642f9e53b723321a3013f2327b8a712c528c53ac5bd9fd2b9420244fcb"
    sha256 cellar: :any,                 sierra:        "ec7e5d41f887db3a41d89eadb64d16119a2d86427afd45de92e7a8ca55ce7ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebed07a9f27fb7c462c9e313dc51dcfb326804fd7715119a32151ee48b4e815d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"twemcache", "--help"
  end
end
