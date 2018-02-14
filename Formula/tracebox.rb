class Tracebox < Formula
  desc "Middlebox detection tool"
  homepage "http://www.tracebox.org/"
  url "https://github.com/tracebox/tracebox.git",
      :tag => "v0.4.4",
      :revision => "4fc12b2e330e52d340ecd64b3a33dbc34c160390"
  head "https://github.com/tracebox/tracebox.git"

  bottle do
    cellar :any
    sha256 "97b9eec6475ebd187edb11b71ce3695c3477d9f8943d8d6d1e7061c6883fce04" => :high_sierra
    sha256 "d476a2ca43ab0ea973b34d7f340248fd81e7e451c5b37834dea35ef8098d6eb4" => :sierra
    sha256 "8da2823065773fb10dadfa07f483e315e0c00e878d2a2b46ac6ceaf6c211cf55" => :el_capitan
  end

  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lua"
  depends_on "json-c"

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
