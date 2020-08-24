class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/sane-project/backends/uploads/8bf1cae2e1803aefab9e5331550e5d5d/sane-backends-1.0.31.tar.gz"
  sha256 "4a3b10fcb398ed854777d979498645edfe66fcac2f2fd2b9117a79ff45e2a5aa"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/sane-project/backends.git"

  bottle do
    sha256 "7dfb3ca74bc32f87a8126bcdb29950d7781882caa2e3175a777e892db69bbd38" => :catalina
    sha256 "c5751d3247be66a5b2019ab23fb3eca1bb4bca86ef051e830bb7fbc27647e9da" => :mojave
    sha256 "b80391595e2dd773f1bf0a093befbf3727801c7110bedfed68f295772399e2b7" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "net-snmp"
  depends_on "openssl@1.1"

  if build.head?
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--with-usb=yes"
    system "make", "install"
  end

  def post_install
    # Some drivers require a lockfile
    (var/"lock/sane").mkpath
  end

  test do
    assert_match prefix.to_s, shell_output("#{bin}/sane-config --prefix")
  end
end
