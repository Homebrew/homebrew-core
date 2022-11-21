class Rssh < Formula
  desc "Restricted shell for use with OpenSSH"
  homepage "http://www.pizzashack.org/rssh"
  url "https://downloads.sourceforge.net/project/rssh/rssh/2.3.4/rssh-2.3.4.tar.gz"
  sha256 "f30c6a760918a0ed39cf9e49a49a76cb309d7ef1c25a66e77a41e2b1d0b40cd9"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_monterey: "15028af39a3549db2d28aedae2d8774c12ac44bce71139ba76269d9d7c2646f7"
    sha256 arm64_big_sur:  "ff8805cca497fcf8b6335aabcd2a468e54c1a425e18ab8a7cab685b7d0a37d11"
    sha256 monterey:       "a465cd87f5ba588770012b57336a2fffefd0d62e1c1ec790c14165e06299d6f2"
    sha256 big_sur:        "c2725b75d2f60da89130f9755da6044aaf5f8342215e6a0cece480f73c657626"
    sha256 catalina:       "320bd3daa0a9cf214c46eaacc16b9a69d3854d8dbac7ed432db91d8afd241790"
    sha256 mojave:         "d31053458aa5853114ce8f1b7adf2aa8f6faee7cba5e7270be783f55d8311791"
    sha256 high_sierra:    "05dd4375824810caf77f7b40d2b1ff0a229e6743f46c755427c428d5ca31f173"
    sha256 sierra:         "aebe589ee047200b1fd0486d3a1fb08c4a601366391e80bcd1e7dcb87ca456e0"
    sha256 el_capitan:     "23891b0317ef29a36b0b8ee9f140193d17ae616983c13f2179d5b317b33e1eee"
  end

  disable! date: "2022-10-19", because: :unmaintained

  # Submitted upstream:
  # https://sourceforge.net/p/rssh/mailman/message/32251335/
  patch do
    url "https://gist.githubusercontent.com/arminsch/9230011/raw/f0c5ed95bbba0be28ce2b5f0d1080de84ec317ab/rsshconf-log-rename.diff"
    sha256 "abd625a8dc24f3089b177fd0318ffc1cf4fcb08d0c149191bb45943ad55f6934"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    # test to check if everything is linked correctly
    system "#{bin}/rssh", "-v"
    # the following test checks if rssh, if invoked without commands and options, fails
    system "sh", "-c", "! #{bin}/rssh"
  end
end
