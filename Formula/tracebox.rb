class Tracebox < Formula
  desc "Middlebox detection tool"
  homepage "http://www.tracebox.org/"
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
    sha256 "86e2c6f4f0ac81f42ea0eeea2545e0e994090b91bcc3a29df9ead84981ec369b" => :high_sierra
    sha256 "48b7de6c88b5c79ea9c6b18d637a12633bb08db31d80cf6877b9a698c4c1c953" => :sierra
    sha256 "e516720d9bd9e928f8f876b4520aac901449ece1bead0b8af561c3ab22a2d584" => :el_capitan
    sha256 "4a8348264f1b28160c41f8d2f723c3a866ba2d430d9ee0388e61d6b15599ce64" => :yosemite
    sha256 "3cf26c9f63b463048eea103b7eac1faeea873dd85391673f590161f4dc0e9416" => :mavericks
    sha256 "03ce10b37ac2bcb7cad32594899fe650fc49cf47ed2f4336e300a18e6f30f12d" => :mountain_lion
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

  def caveats; <<-EOS.undent
    Tracebox requires superuser privileges e.g. run with sudo.

    You should be certain that you trust any software you are executing with
    elevated privileges.
    EOS
  end

  test do
    system bin/"tracebox", "-v"
  end
end
