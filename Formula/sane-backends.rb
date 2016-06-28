class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"

  head "https://anonscm.debian.org/cgit/sane/sane-backends.git"

  stable do
    url "https://fossies.org/linux/misc/sane-backends-1.0.25.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.25.orig.tar.gz"
    sha256 "a4d7ba8d62b2dea702ce76be85699940992daf3f44823ddc128812da33dc6e2c"
    # Fixes some missing headers missing error. Reported upstream
    # https://lists.alioth.debian.org/pipermail/sane-devel/2015-October/033972.html
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/sane-backends/1.0.25-missing-types.patch"
      sha256 "f1cda7914e95df80b7c2c5f796e5db43896f90a0a9679fbc6c1460af66bdbb93"
    end
  end

  bottle do
    sha256 "e8cd147368ca911b15da016a09cb3d0b58843b5169291a75fe2a42fed7c9c887" => :el_capitan
    sha256 "006f73ab657625408f5d56ec1596498b911781164db60cc4518370b2a08686f3" => :yosemite
    sha256 "168d5dc5f38b6e568f2d757de77dc86c7b3bab1a84a50f1b30103eb9ba9bf367" => :mavericks
    sha256 "483533ac9a7d48d15350afaed266ac9472cd8c945fdd34d610253253e3c384e7" => :mountain_lion
  end

  option :universal

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libusb-compat"
  depends_on "openssl"

  def install
    ENV.universal_binary if build.universal?
    ENV.j1 # Makefile does not seem to be parallel-safe
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--enable-libusb",
                          "--disable-latex"
    system "make"
    system "make", "install"

    # Some drivers require a lockfile
    (var+"lock/sane").mkpath
  end
end
