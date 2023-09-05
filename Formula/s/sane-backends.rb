class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/sane-project/backends/uploads/110fc43336d0fb5e514f1fdc7360dd87/sane-backends-1.2.1.tar.gz"
  sha256 "f832395efcb90bb5ea8acd367a820c393dda7e0dd578b16f48928b8f5bdd0524"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "fb030d64b3e6974586384b4398b4652a109dfb5723e21fc4e237170d59870392"
    sha256 arm64_monterey: "dde5b1ae3dba8beba083c3adff88626792e0ca4b68f2eaddfd445122fa06e561"
    sha256 arm64_big_sur:  "816f955ec13f1767fa9bf3e721a3fb55a06bd17482c3db58fca4dab8c1a0ea44"
    sha256 ventura:        "dd313349947d2636690227b64fcaf52d17b9389851787906f37bf91351076775"
    sha256 monterey:       "0de46efc5c9fdfb44ee043fff93b630b88cb678de1cda40d62c30575d7979435"
    sha256 big_sur:        "68a5dadc176006ccaac9957884dfa582bde20c846e0567201efb381e5cc190af"
    sha256 x86_64_linux:   "d015337c002f86128e3af57eb58afdc40ad8716fdde860c60c939cc803245117"
  end

  head do
    url "https://gitlab.com/sane-project/backends.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "net-snmp"

  uses_from_macos "python" => :build
  uses_from_macos "libxml2"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
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
