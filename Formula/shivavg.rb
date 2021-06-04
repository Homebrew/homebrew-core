class Shivavg < Formula
  desc "OpenGL based ANSI C implementation of the OpenVG standard"
  homepage "https://sourceforge.net/projects/shivavg/"
  url "https://downloads.sourceforge.net/project/shivavg/ShivaVG/0.2.1/ShivaVG-0.2.1.zip"
  sha256 "9735079392829f7aaf79e02ed84dd74f5c443c39c02ff461cfdd19cfc4ae89c4"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8d928dc2b52759bad7394d50cc55b1b6d512fbbbba9fe902cb5e3296bd0e915a"
    sha256 cellar: :any, big_sur:       "2d89164bed390c7556dbf88d65bb25775ea17bc04e1e4bfb026792ef64fba6ed"
    sha256 cellar: :any, catalina:      "b7c8f247b6db49cd1cabd2efd39d034c25d727f27bce09a329d9cc3c8e36a621"
    sha256 cellar: :any, mojave:        "6ddd7a34be8f7650a001df8b4ad627d574ac2c14e71d239a5a263d1848b12149"
    sha256 cellar: :any, high_sierra:   "bea07d86639a8d24f90324552ed1880fd6a162141a394338e0ad2a81a3abeb5f"
    sha256 cellar: :any, sierra:        "f92bdb7b86632d7bf59d25259e26eece00e502759dd52adaac7495424290da4a"
    sha256 cellar: :any, el_capitan:    "3e9de2887110c90051ad5b89080f62cd5990ae39f8fdef02a4c50ba11e413ca8"
    sha256 cellar: :any, yosemite:      "f3de3b35fcfeff41c1836bc7722579d1d4b461e10d4152802bae1ab48b5a3bbb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "/bin/sh", "autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-example-all=no"
    system "make", "install"
  end
end
