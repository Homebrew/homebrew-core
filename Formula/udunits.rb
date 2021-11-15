class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "https://artifacts.unidata.ucar.edu/repository/downloads-udunits/udunits-2.2.28.tar.gz"
  sha256 "590baec83161a3fd62c00efa66f6113cec8a7c461e3f61a5182167e0cc5d579e"

  livecheck do
    url "https://artifacts.unidata.ucar.edu/service/rest/repository/browse/downloads-udunits/"
    regex(%r{href=.*?/udunits[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "64af7e42ad61c45d6f1790d747c9e3d8bbd8634a86fc51961646b31a16f64edf"
    sha256 arm64_big_sur:  "d7abb17bec04dc4aede1c62e24766a4f31c6d4c4cc5f1716fcb56f1da06b0492"
    sha256 monterey:       "ed2147b73e154d445d1959b871e956975bc2ed2d33757d9ed57df1114af2222c"
    sha256 big_sur:        "cb3a237ce5aa71c094ece2c9a7ba3199238d8facf053760a5f29ebec93f29e53"
    sha256 catalina:       "5787ba730b9969468621db38503a036de75aea0a8e62cbd253e9c73262355419"
    sha256 mojave:         "c1c3d199cfc58d42469bfb423e269dd9b7771e155f710e0e46bfb6a33fdc19f4"
    sha256 x86_64_linux:   "9df6142349c78d0ebb0922ea53c48f702ca83cf223513437022086ee332c22a8"
  end

  head do
    url "https://github.com/Unidata/UDUNITS-2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "texinfo" => :build
  uses_from_macos "expat"

  def install
    system "autoreconf", "--verbose", "--install", "--force" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_match(/1 kg = 1000 g/, shell_output("#{bin}/udunits2 -H kg -W g"))
  end
end
