class Tracebox < Formula
  desc "Middlebox detection tool"
  homepage "http://www.tracebox.org/"
  revision 1
  head "https://github.com/tracebox/tracebox.git"

  stable do
    url "https://github.com/tracebox/tracebox.git",
        :tag => "v0.4.2",
        :revision => "2e3326500ddf084bf761e83516909538d26240da"

    # Remove for > 0.4.2
    # Upstream commit from 2 Oct 2017 "Remove [--dirty] from the displayed
    # version string"
    patch do
      url "https://github.com/tracebox/tracebox/commit/5ee627c.patch?full_index=1"
      sha256 "af6fda9484e1188acf35c0fb5f871cebc608c8122e5ad1d94569fe30321549cc"
    end
  end

  bottle do
    cellar :any
    sha256 "a48ec11757598455e6eff5603a5a0e6f4d2497efd4ebd0ba37829e148aa9d8df" => :high_sierra
    sha256 "43bae78b21fc5a839c805004986b1ffd2e0ac8f5589f2d53990874874d1d7251" => :sierra
    sha256 "887104507eb7457f644f78143758b4c570877e10d8a9a430d165911c6692febf" => :el_capitan
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
