class Tracebox < Formula
  desc "Middlebox detection tool"
  homepage "https://www.github.com/tracebox/tracebox"
  url "https://github.com/tracebox/tracebox.git",
      tag:      "v0.4.4",
      revision: "4fc12b2e330e52d340ecd64b3a33dbc34c160390"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/tracebox/tracebox.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, big_sur:  "b972c4ea4a3c130bb45f8b9a97441ea3e9b7aae20de0c1c33d5e1a19596825c1"
    sha256 cellar: :any, catalina: "cf183ba6385036080157a7dc032453e4c28bde55a2ebf4830e8b990b3c83e1c8"
    sha256 cellar: :any, mojave:   "ba193e6a2a415a8fefd90890daaa21a19c3bdabeb14504699a558207affdc216"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "json-c"
  depends_on "libpcap"
  depends_on "lua"

  def install
    ENV.append_to_cflags "-I#{Formula["libpcap"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libpcap"].opt_lib} -lpcap"
    ENV.libcxx
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-libpcap=yes",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Tracebox requires superuser privileges e.g. run with sudo.

      You should be certain that you trust any software you are executing with
      elevated privileges.
    EOS
  end

  test do
    system bin/"tracebox", "-v"
  end
end
