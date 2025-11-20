class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/en/latest/softhsm/"
  url "https://github.com/opendnssec/opendnssec/releases/download/2.1.14/softhsm-2.6.1.tar.gz"
  sha256 "61249473054bcd1811519ef9a989a880a7bdcc36d317c9c25457fc614df475f2"
  license "BSD-2-Clause"

  # We check the GitHub repo tags instead of https://dist.opendnssec.org/source/
  # since the aforementioned first-party URL has a tendency to lead to an
  # `execution expired` error.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 arm64_tahoe:   "b2bd259c0e4982412af4f69451373a1d2cc03e43889adb5262f8d8873c3ede4f"
    sha256 arm64_sequoia: "34109f42f84fc58c9d6d9c9d668dab3ca9f71fce3d5f2962f679d730edcae3c4"
    sha256 arm64_sonoma:  "2f329600e4d3ba0bc070d32692cf4805c43f0a25298d4d37b64a7445c0847fa6"
    sha256 sonoma:        "210b718fbb84080b2a3b56fe0399047a7133423f4e7929e4d7ecd40e8a3357ea"
    sha256 arm64_linux:   "a15ebcb5cb99c673cfa7aadcda2e0b1f2e8e6ba693d3d9fd91ed922c8de26ae3"
    sha256 x86_64_linux:  "264fceddb0f4bce4bee697b2868f2d352768f4384088574b2f711b7af6894dd6"
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
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{pkgetc}",
                          "--with-crypto-backend=openssl",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--disable-gost",
                          *std_configure_args
    system "make", "install"

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
