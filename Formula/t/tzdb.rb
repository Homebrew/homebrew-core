class Tzdb < Formula
  desc "Time Zone Database"
  homepage "https://www.iana.org/time-zones"
  url "https://data.iana.org/time-zones/releases/tzdb-2026c.tar.lz"
  sha256 "427a11b1c5f2ebccad18f11650221c4f0465b4f1bb7f44dd02ff192d2808d944"
  license all_of: ["BSD-3-Clause", :public_domain]

  livecheck do
    url :homepage
    regex(/href=.*?tzdb[._-]v?(\d+(?:\.\d+)*[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8a6bb1e350180b9f4fd663b978a62f3b1e619abe4dbe44bd036bc11d13929e44"
    sha256 arm64_sequoia: "57f2e3df9b23e8a516d19003e58e8913cd9722871fb35d276bc828c99abc520e"
    sha256 arm64_sonoma:  "5f63a56aa763704156b8975e15ae36287bd1b7b8e1fa6a23de872b716a338747"
    sha256 sonoma:        "5a103b160d721ec140a4755b4646a0a460e303c0e0d40448a5919fa0285086ac"
    sha256 arm64_linux:   "f1c71b47d7bd999f7a4c5f65195c12d44ba7c1382b81a9f73c4afbb0d0dd9263"
    sha256 x86_64_linux:  "c7c074142d223ac902e8c5548238fb5e6b25f355b31677d7fce73ad80311839d"
  end

  on_macos do
    depends_on "gettext"
  end

  def localtime
    etc/"localtime"
  end

  def install
    make_args = %W[
      CFLAGS=#{ENV.cflags}
      USRDIR=#{prefix}
      TZDEFAULT=#{localtime}
    ]
    make_args << "LDLIBS=-lintl" if OS.mac?

    system "make", *make_args, "install"
  end

  def post_install
    # Generate default localtime, from Makefile.
    system sbin/"zic", "-l", "Factory", "-p", "-", "-t", localtime
  end

  test do
    assert_match "UTC", shell_output("#{bin}/zdump UTC")
  end
end
