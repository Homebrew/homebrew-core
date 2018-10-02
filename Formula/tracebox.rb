class Tracebox < Formula
  desc "Middlebox detection tool"
  homepage "https://www.tracebox.org/"
  url "https://github.com/tracebox/tracebox.git",
      :tag => "v0.4.4",
      :revision => "4fc12b2e330e52d340ecd64b3a33dbc34c160390"
  revision 1
  head "https://github.com/tracebox/tracebox.git"

  bottle do
    cellar :any
    sha256 "0e22b5bc6204f1c344f83d8ec69a95bd61b7ab6365c619dfa5dcb53df04c576a" => :mojave
    sha256 "e3e8333e7674ff8829df657bd759353fecc45c6d982afbc33cf35774a6ec23ec" => :high_sierra
    sha256 "52a3ff0ecd8903cee1be17802dfe0624dc89858088354132496a241ea4207561" => :sierra
    sha256 "2c0b3b4bb42d38aafdb702f3b7a5e514588ce75dd5dc459368d40273332b3a7d" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "json-c"
  depends_on "lua"

  needs :cxx11

  def install
    ENV.libcxx
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
    Tracebox requires superuser privileges e.g. run with sudo.

    You should be certain that you trust any software you are executing with
    elevated privileges.
  EOS
  end

  test do
    system bin/"tracebox", "-v"
  end
end
