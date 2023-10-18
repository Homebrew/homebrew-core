class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.6.tar.gz"
  sha256 "2342cb85eff65ac52fe9e52c2eebe05436af6c5661d649da8e922616ecc8693a"
  license "ISC"
  revision 1

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "3964e40015b89f49ad3ca9c94d17ad95b64b8c7868b116c8d89c048c59a3bf25"
    sha256 arm64_ventura:  "c3c52fa6a567e7e436eebc4e1a9d802d68af733badafe8b14fe11adf64116069"
    sha256 arm64_monterey: "397f0a100c41007b9c03a43e4a0f87771682fbf10bb523bbf9f0f164fbb6d9d0"
    sha256 sonoma:         "6c63535cd55429e08f3955993abaa3654e2eae1c404c9192e515034755578b0b"
    sha256 ventura:        "154bc99c2c09ba8b3e98ddeba5690f197f36c132550d3813f17cc9bc5338fcda"
    sha256 monterey:       "cb98abcb905a17915d8d98143bd943e6d50e4cb78616c119864586d90282aace"
    sha256 x86_64_linux:   "457612495cdab35d74fb76291428fa197f7493abcbab0157bb9f5bb525c11d0f"
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
