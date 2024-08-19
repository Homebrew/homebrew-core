class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-9.1.tar.gz"
  sha256 "0e8248d079401df6f18b41de13694452a147dff252db6b9a76bdc3cdc5ca2b0b"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "bf1db5429aa4d2482a107f5ea5f4f5f7b169c1786952d92be87c5d881750694e"
    sha256 arm64_ventura:  "0e849d292abbf70546fe580453ae7902decedc5b0f062ba0c4b802a760c5a57c"
    sha256 arm64_monterey: "cd478dc811244dc35e0d95c815cd3149cb458967f8e217651ed34f21525edd8a"
    sha256 sonoma:         "42b738e49407f19f168b1bdc405713372558496c547db0392f8e9f6806e32c8c"
    sha256 ventura:        "751eeb621d46a9e15e0ae18e17e5bf59abffc03fb43c0a5ae25d178ad82545f0"
    sha256 monterey:       "46214825406cea8ad26171b590dae4577de609d27c0cd13ad3fd40352b9edada"
    sha256 x86_64_linux:   "0e8ae78ec8c6ffe411677db1c6e9e6dcc4eb1e0afc2c302f663d0792a070f2d8"
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
