class Samba < Formula
  desc "SMB/CIFS file, print, and login server for UNIX (keg-only)"
  homepage "https://samba.org/"
  url "https://download.samba.org/pub/samba/samba-4.8.5.tar.gz"
  sha256 "e58ee6b1262d4128b8932ceee59d5f0b0a9bbe00547eb3cc4c41552de1a65155"

  keg_only :provided_by_macos
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "krb5"
  depends_on "openssl"
  depends_on "readline" # Without the readline dependency the build fails on macOS 10.14+

  def install
    # Samba can be used to share directories with the guest in QEMU user-mode (SLIRP) networking
    # with the `-net user,id=net0,smb=/share/this/with/guest` option.
    # Without this formula QEMU will attempt use the system smbd and silently fail to setup
    # the share. By building samba.org sources as a keg-only formula we can use it as an
    # optional dependency for QEMU.
    system "./configure",
           "--disable-cephfs",
           "--disable-cups",
           "--disable-iprint",
           "--disable-glusterfs",
           "--disable-python",
           "--without-acl-support",
           "--without-ad-dc",
           "--without-ads",
           "--without-dnsupdate",
           "--without-ldap",
           # will be needed in 4.9.0: "--without-json-audit",
           "--without-ntvfs-fileserver",
           "--without-pam",
           "--without-regedit",
           "--without-syslog",
           "--without-utmp",
           "--without-winbind",
           # samba requires krb5 version 1.9+ so we can't use the system version
           "--with-system-mitkrb5", Formula["krb5"].opt_prefix.to_s,
           # The following libraries are not installed correctly so tell the build system to build them static:
           # Unfortunately this causes smbd to trap at runtime, so as a workaround manually install the dylibs
           # "--builtin-libraries=ldb,talloc,tdb,tevent",
           "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    # The following libraries are not installed into the prefix by make install:
    copy_file "./bin/default/lib/ldb/libldb.dylib", "#{lib}/libldb.dylib"
    copy_file "./bin/default/lib/talloc/libtalloc.dylib", "#{lib}/libtalloc.dylib"
    copy_file "./bin/default/lib/tdb/libtdb.dylib", "#{lib}/libtdb.dylib"
    copy_file "./bin/default/lib/tevent/libtevent.dylib", "#{lib}/libtevent.dylib"
  end

  test do
    system "#{sbin}/smbd", "--version"
    system "#{sbin}/smbd", "--help"
  end
end
