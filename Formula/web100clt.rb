class Web100clt < Formula
  desc "Command-line version of NDT diagnostic client"
  homepage "https://software.internet2.edu/ndt/"
  url "https://software.internet2.edu/sources/ndt/ndt-3.7.0.2.tar.gz"
  sha256 "bd298eb333d4c13f191ce3e9386162dd0de07cddde8fe39e9a74fde4e072cdd9"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "d0657f34a029afff0189246744dd03d276ea9091e61b6dd208aea81b7e58cf36" => :mojave
    sha256 "d6d8ecf4d6e7aa7da29fab7d2fe58db4c6da2da60b777be22d12854c15ea0887" => :high_sierra
    sha256 "a6c81629d7e8171694cc14ebd5a1fc2280f23643be442f1103ac5a84403e344a" => :sierra
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
