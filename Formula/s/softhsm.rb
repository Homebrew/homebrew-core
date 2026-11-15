class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.softhsm.org/"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/softhsm/SoftHSMv2.git", branch: "main"

  stable do
    url "https://github.com/softhsm/SoftHSMv2/archive/refs/tags/2.7.0.tar.gz"
    sha256 "be14a5820ec457eac5154462ffae51ba5d8a643f6760514d4b4b83a77be91573"

    # OpenSSL 4.0 support was added with memory leak fixes
    patch do
      url "https://github.com/softhsm/SoftHSMv2/commit/57e10cbbe75069be92c7e9720c180a05833481fc.patch?full_index=1"
      sha256 "d60af158e0fcbb72458292b86455ec949d4c550cd009274841cbe94b4ded06dd"
      type :backport
    end
    patch do
      url "https://github.com/softhsm/SoftHSMv2/commit/d23ea09d318c03c033420d065f1c64b019cc94ed.patch?full_index=1"
      sha256 "b8f13d1d584c39d0c04443d756fdb7dadbfe8ab056dd7d290313afcfd93d96ca"
      type :backport
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "b9879d4e2e1afab76e20aad0009042903d3064ca7883ec16fd0d420c2176e326"
    sha256 arm64_tahoe:       "40d5a8ce7b320bb727da8ee48588382e910ba4592c76d55ca2ce99183ce37d64"
    sha256 arm64_sequoia:     "e9bd882bc09343a718f4a4447d4cf724388a9bf4f6e381761325bb4cd492fdc9"
    sha256 arm64_linux:       "7c9801b3af5f45956c9a5acf881c1892285ac334337fa08b8a3b8e9d9173a4c6"
    sha256 x86_64_linux:      "348a91ac03ccb1c57779cad1d145ced926b1dd472c2a5e83ba8c429624ec4743"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  deny_network_access!

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{pkgetc}",
                          "--with-crypto-backend=openssl",
                          "--with-openssl=#{formula_opt_prefix("openssl@4")}",
                          "--disable-gost",
                          *std_configure_args
    system "make", "install"

    (var/"lib/softhsm/tokens").mkpath
  end

  test do
    (testpath/"softhsm2.conf").write("directories.tokendir = #{testpath}")
    ENV["SOFTHSM2_CONF"] = testpath/"softhsm2.conf"
    system bin/"softhsm2-util", "--init-token", "--slot", "0",
                                "--label", "testing", "--so-pin", "1234",
                                "--pin", "1234"
    system bin/"softhsm2-util", "--show-slots"
  end
end
