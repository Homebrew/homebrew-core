class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-9.3.tar.gz"
  sha256 "0fc209e15e41d9dc780ad365923a1e358ce37ffc814cf5282bc26e9d670e17bd"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "d2253f89f754114579dc49a97fe8f8c455328281cbd8973a507a501b92fc53ae"
    sha256 arm64_sonoma:  "549b12dc92a31b5d2e2e8d101fdc57c3fcf686075360ae5b5ef1fc28b074e7ec"
    sha256 arm64_ventura: "0add486ecc301cc09d346522f86be0eb50b44c88124d58e9187c431f3882a44e"
    sha256 sonoma:        "54cd1095c2c2c338a50c0e83f6868412e22e961be0fde8665272f4b2516d9a00"
    sha256 ventura:       "1eb406f97d21f94591aa82af5b76f1ec2c3e9270038eaa2f4ca2f994a80cc316"
    sha256 x86_64_linux:  "ba880cf10fd69db73ab54d1b861bb35ebbf15f91333bce53e9ab64dbdb739817"
  end

  depends_on "pkg-config" => :build
  depends_on "libretls"
  depends_on "openssl@3"
  depends_on "rsync"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--with-rsync=#{Formula["rsync"].opt_bin}/rsync",
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  def post_install
    # make the var/db,cache/rpki-client dirs
    (var/"db/rpki-client").mkpath
    (var/"cache/rpki-client").mkpath
  end

  test do
    assert_match "VRP Entries: 0 (0 unique)", shell_output("#{sbin}/rpki-client -n -d . -R . 2>&1")
    assert_match "rpki-client-portable #{version}", shell_output("#{sbin}/rpki-client -V 2>&1")
  end
end
