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
    sha256 "0ec57d1c7ba9701a394fda6f9e87c328673833fab0f72060e297716f55c7c67e" => :high_sierra
    sha256 "9b42586adbd0b639e3722c9dd43f67d350b36cbab148aca454dfd57bc01c457f" => :sierra
    sha256 "dfc1dd387e7b947007439897e55b2ab2c77270be143894dd90d8fb6d540019d2" => :el_capitan
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
