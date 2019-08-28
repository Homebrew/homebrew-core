class Web100clt < Formula
  desc "Command-line version of NDT diagnostic client"
  homepage "https://software.internet2.edu/ndt/"
  url "https://software.internet2.edu/sources/ndt/ndt-3.7.0.2.tar.gz"
  sha256 "bd298eb333d4c13f191ce3e9386162dd0de07cddde8fe39e9a74fde4e072cdd9"
  revision 1

  bottle do
    sha256 "2b37669adf9e8248295fc31e95659697dcc4b47db89e9db11cea506f02863dfe" => :mojave
    sha256 "93f6e31d1b28eea6a6f64d6bcacf39db135725bd6130a88173a724c6968c8c62" => :high_sierra
    sha256 "be444b693ab664de5d521242702bf91a1518cd8945d7d6db1b03126f8a2638bb" => :sierra
    sha256 "d0998cd6fb89d689aeb6f88bcd92039ad88daa3aef8b718bbcb8be6a3c4a7e39" => :el_capitan
    sha256 "e2acae1966b2897ef89dcec1610e164f4c8bee054369d2012e1619853c6674d0" => :yosemite
    sha256 "86b6d51af3d9e33db8220d8834d04aeed0241872a28aeac697b4357d2afbcc2e" => :mavericks
  end

  depends_on "i2util"
  depends_on "jansson"
  depends_on "openssl@1.1"

  # fixes issue with new default secure strlcpy/strlcat functions in 10.9
  # https://github.com/ndt-project/ndt/issues/106
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/37aa64888341/web100clt/ndt-3.6.5.2-osx-10.9.patch"
    sha256 "86d2399e3d139c02108ce2afb45193d8c1f5782996714743ec673c7921095e8e"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"

    # we only want to build the web100clt client so we need
    # to change to the src directory before installing.
    system "make", "-C", "src", "install"
    man1.install "doc/web100clt.man" => "web100clt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/web100clt -v")
  end
end
