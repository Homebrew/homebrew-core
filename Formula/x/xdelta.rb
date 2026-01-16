class Xdelta < Formula
  desc "Binary diff, differential compression tools"
  homepage "https://github.com/jmacd/xdelta"
  url "https://github.com/jmacd/xdelta/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "7515cf5378fca287a57f4e2fee1094aabc79569cfe60d91e06021a8fd7bae29d"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ee37900b3dc66de43cbffbd9fc486d9532f519cf36a10c66a198c64ae7a94e07"
    sha256 cellar: :any,                 arm64_sequoia:  "2a4d522dbb3bd2fb960b11396eb6f2f2cb5525acab75a5fc949676b261c8468b"
    sha256 cellar: :any,                 arm64_sonoma:   "aa71b9bbaa25a30a189c6f2c1772f3cbe44146eae104a830e5fee0d544a56d79"
    sha256 cellar: :any,                 arm64_ventura:  "63a96424b3e3b7c2c501fdb0b10ae2847cec321daeda40e0bfc1c4125cafd22a"
    sha256 cellar: :any,                 arm64_monterey: "18018770f5aec11098c6a02b6a88eb7db07edffb5e04d947b3e82de41925af8a"
    sha256 cellar: :any,                 arm64_big_sur:  "4bf8a2d96c0ee4e20beafd81762a80e21bbb9fe400796e02392cb18777f0c6a9"
    sha256 cellar: :any,                 sonoma:         "cab53d9abbfb5e25e8401c04b68402f5678f0dbd731cee77aa089203768adbc2"
    sha256 cellar: :any,                 ventura:        "84d6c37a23ea9ad421cb934be9b559351beffc348ad56a1395ca4e514934c205"
    sha256 cellar: :any,                 monterey:       "cead50bfce3fa3e6dba28a28804b2741748f30f1baafd1bf3fe192bb4d34e6c2"
    sha256 cellar: :any,                 big_sur:        "98fa35dfab2175bb199d3878788734096430e118f3f17cdde9c74ea99af62538"
    sha256 cellar: :any,                 catalina:       "5b5eae08cf9d1d5e37dc42f0d557670477bae10adf28278bbb4f88ec83a5a2c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "07505153f0433a184f123e5f0d9468511854f2fc10b811bc45cf9628b9da14d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4015bbc1061c1ac1ba9b56e9465b2b18bd22f1557e79651f1cf9feaf5e37c486"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz"

  def install
    cd "xdelta3" do
      system "autoreconf", "--force", "--install", "--verbose"
      system "./configure", "--with-liblzma", *std_configure_args
      system "make", "install"
    end
  end

  test do
    system bin/"xdelta3", "config"
  end
end
