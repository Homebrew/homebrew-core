class Tracebox < Formula
  desc "Middlebox detection tool"
  homepage "https://www.github.com/tracebox/tracebox"
  url "https://github.com/tracebox/tracebox.git",
      tag:      "v0.4.4",
      revision: "4fc12b2e330e52d340ecd64b3a33dbc34c160390"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/tracebox/tracebox.git"

  bottle do
    cellar :any
    sha256 "7d942d1431c44893cba7ae8b6b3e24f632042051fd5e1039ad3c6ad59845f938" => :big_sur
    sha256 "ea8e698fabb1071549a35f2af430272d0e705501078b5d9aad938f3fa5c3ded9" => :catalina
    sha256 "a1a34c7c29255f429879e0687c014ef9140c78915c00617a82134cefa91d7a3c" => :mojave
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
