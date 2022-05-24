class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.6.1.tar.gz"
  sha256 "61249473054bcd1811519ef9a989a880a7bdcc36d317c9c25457fc614df475f2"
  license "BSD-2-Clause"

  # We check the GitHub repo tags instead of https://dist.opendnssec.org/source/
  # since the aforementioned first-party URL has a tendency to lead to an
  # `execution expired` error.
  livecheck do
    url "https://github.com/opendnssec/SoftHSMv2.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "c3e55a3b5f71b28da6a9fe63d3008a30d1d9276acc89ca677717bdc87c9be668"
    sha256 arm64_big_sur:  "878fda1e9a3ab2de52ecc4244044971ad3e38909e080f77cb7973a5f797359c8"
    sha256 monterey:       "99780ecb60f55ec1959ee5ca34b8f17ff1a6767f3a3f23dffeb0b193fa4bd865"
    sha256 big_sur:        "08a0d7a61d2b8d4f12253d3e5404ce43456fbb864dc9fb88999132f96a15c267"
    sha256 catalina:       "6da111cdadbcf0127882e2bec5b3844454fd9b4e00a08d1fa49aa2f389b7062c"
    sha256 mojave:         "b7abd86dfec3d10f5e5cde00f2bcd5e0e19e2d9674c50a431db1195c4655dfec"
    sha256 high_sierra:    "73c40f26209dbf29280c16aefdfb492c749d8e14e4cbf83dc2a5b566c22f6bc9"
    sha256 x86_64_linux:   "ccf8a6487c0cdc7ed07929e739d98029daf389f9c0b8b2924357216ab8b8b8e7"
  end

  head do
    url "https://github.com/opendnssec/SoftHSMv2.git", branch: "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  depends_on "openssl@1.1"

  def install
    system "sh", "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/softhsm",
                          "--localstatedir=#{var}",
                          "--with-crypto-backend=openssl",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--disable-gost"
    system "make", "install"
  end

  def post_install
    (var/"lib/softhsm/tokens").mkpath
  end

  test do
    (testpath/"softhsm2.conf").write("directories.tokendir = #{testpath}")
    ENV["SOFTHSM2_CONF"] = "#{testpath}/softhsm2.conf"
    system "#{bin}/softhsm2-util", "--init-token", "--slot", "0",
                                   "--label", "testing", "--so-pin", "1234",
                                   "--pin", "1234"
    system "#{bin}/softhsm2-util", "--show-slots"
  end
end
