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
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_sequoia:  "469b96859edc8a37e5e3dd99aab7c7f615dad572d7ca71576fe7efa5059244a2"
    sha256 arm64_sonoma:   "1b90ff62e89b9461223d118fa261551030e232218110b9366d7d097553d2e64e"
    sha256 arm64_ventura:  "d41a143c3d5e8ea1b7f932c41cea27dbb64341d7e28bfb4c61af68aa68499b77"
    sha256 arm64_monterey: "c4912791b41e00485fc4b07abf4a9f5ffd0e75d613dd3e316b15f837e4fcc95d"
    sha256 arm64_big_sur:  "42a2031bb207ba74def4b64a1594c3827c6f2329995b52b7d84a16495c8d18df"
    sha256 sonoma:         "2883177ca802dcf95f7fe8eaf5118399eaab1c6cf1e1d3f2d8b4a6771708f2d7"
    sha256 ventura:        "6afda1d652a97fd5fbbe602d31d9efc675ffcc171c1978a447c864af97b8d883"
    sha256 monterey:       "320f44fb1c860b9953b29260ca75fa947c728db78fea1a72c6796d5ea537624d"
    sha256 big_sur:        "ceaa2a468dd99798cb775406dbeaf169565b35517d36b06fdd2abba6ed9d754a"
    sha256 catalina:       "f18b5f1c33b98f07f14233e90e412900a22d79f4b04946bdd1fdd28a04dbda01"
    sha256 arm64_linux:    "9fc20743d5a7ce1147876d8811fb186a22d37f7c8e55c1dbb8c07a64c08c0a0a"
    sha256 x86_64_linux:   "87b3b85891df32b03e9b362ed76ed435095c6c72d40d460df18986869d701ee5"
  end

  head do
    url "https://github.com/opendnssec/SoftHSMv2.git", branch: "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkgconf" => :build
  end

  depends_on "openssl@3"

  def install
    system "sh", "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--sysconfdir=#{etc}/softhsm",
                          "--localstatedir=#{var}",
                          "--with-crypto-backend=openssl",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--disable-gost",
                          *std_configure_args
    system "make", "install"
  end

  def post_install
    (var/"lib/softhsm/tokens").mkpath
  end

  test do
    (testpath/"softhsm2.conf").write("directories.tokendir = #{testpath}")
    ENV["SOFTHSM2_CONF"] = "#{testpath}/softhsm2.conf"
    system bin/"softhsm2-util", "--init-token", "--slot", "0",
                                "--label", "testing", "--so-pin", "1234",
                                "--pin", "1234"
    system bin/"softhsm2-util", "--show-slots"
  end
end
