class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/v0.45.tar.gz"
  sha256 "780faa7330f306430aaf895984c936f451a8d35555145eff5451dc57b0c3ba8c"
  license "GPL-2.0-or-later"
  head "https://github.com/hanslub42/rlwrap.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "cd22027a87a3827a13573d698a516eb718c8231316e7452462080e93c9d2c744"
    sha256 big_sur:       "027f54d1c75ddf6a0c137ecf5230294e624f3f4a36c73ff9d596296d0c39c88b"
    sha256 catalina:      "a1ae981793d1390617c91c03d3044dae258f7db8c2e182cab442766a973713b7"
    sha256 mojave:        "8f9ceb154b1cbb737161455173c554c34c47b1bf88eb2f4838b0e2b71b88d725"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-v", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rlwrap", "--version"
  end
end
