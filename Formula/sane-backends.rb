class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  revision 1

  head "https://anonscm.debian.org/cgit/sane/sane-backends.git"

  stable do
    url "https://fossies.org/linux/misc/sane-backends-1.0.25.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.25.orig.tar.gz"
    sha256 "a4d7ba8d62b2dea702ce76be85699940992daf3f44823ddc128812da33dc6e2c"

    # Fixes some missing headers missing error. Reported upstream
    # https://lists.alioth.debian.org/pipermail/sane-devel/2015-October/033972.html
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/6dd7790c/sane-backends/1.0.25-missing-types.patch"
      sha256 "f1cda7914e95df80b7c2c5f796e5db43896f90a0a9679fbc6c1460af66bdbb93"
    end
  end

  bottle do
    sha256 "9ae23943f94606cef5b487b13316de6315b1902649c4b727a1e2fcb3b7cff6f0" => :sierra
    sha256 "69f378b3f6de3b875e1a1faa732f1ed42a7c76e79f47f0e4b642691f3a166140" => :el_capitan
    sha256 "3eb8383ea5af581ae71a5179432c0d654f2001922f7cbd747d2e5e15165eaf2f" => :yosemite
    sha256 "37f8e076bdddbdc868076456c308d21fbbef40ab647297f69bf5ca4b88a07688" => :mavericks
  end

  option :universal

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libusb-compat"
  depends_on "openssl"
  depends_on "net-snmp"

  def install
    ENV.universal_binary if build.universal?
    ENV.deparallelize # Makefile does not seem to be parallel-safe
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--enable-libusb",
                          "--disable-latex"
    system "make"
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
