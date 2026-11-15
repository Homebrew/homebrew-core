class Samba < Formula
  # Samba can be used to share directories with the guest in QEMU user-mode
  # (SLIRP) networking with the `-net nic -net user,smb=/share/this/with/guest`
  # option. The shared folder appears in the guest as "\\10.0.2.4\qemu".
  desc "SMB/CIFS file, print, and login server for UNIX"
  homepage "https://www.samba.org/"
  url "https://download.samba.org/pub/samba/stable/samba-4.25.1.tar.gz"
  sha256 "7f367545bca69aa96897628f82f0f04d4b66b3bcb36cb978b9bb952c4b4c428d"
  license "GPL-3.0-or-later"
  compatibility_version 2

  livecheck do
    url "https://www.samba.org/samba/download/"
    regex(/href=.*?samba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "a25bfa55d86e95e514ea4c5e9ef29a960d89b185eea0eebd495741c8967c25a3"
    sha256 arm64_tahoe:       "0cf546d7167ecb38f926b3b9e31cd83d8ffdeaf448d2f17814c571fc3cdb7fca"
    sha256 arm64_sequoia:     "97ee13a674e073786f2bb1e2c11e70ad0fec9fd38f58b429e31e6db5c7f32380"
    sha256 arm64_linux:       "3eec920fc7d8fa1add07edb473da6c5f4bd536a59d591156005ac3d56737dc12"
    sha256 x86_64_linux:      "61b45757185371859bc43afd0032451e2ddc0d03c13c37dd6f60b86f6a8284ac"
  end

  depends_on "bison" => :build
  depends_on "cmocka" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  # icu4c can get linked if detected by pkg-config and there isn't a way to force disable
  # without disabling spotlight support. So we just enable the feature for all systems.
  depends_on "icu4c@79"
  depends_on "krb5"
  depends_on "libtasn1"
  depends_on "lmdb"
  depends_on "popt"
  depends_on "readline"
  depends_on "talloc"
  depends_on "tdb"
  depends_on "tevent"

  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build # configure requires python3 binary
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libtirpc"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "jena", because: "both install `tdbbackup` binaries"
  conflicts_with "puzzles", because: "both install `net` binaries"

  resource "Parse::Yapp" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/W/WB/WBRASWELL/Parse-Yapp-1.21.tar.gz"
      sha256 "3810e998308fba2e0f4f26043035032b027ce51ce5c8a52a8b8e340ca65f13e5"
    end
  end

  # Give macOS libraries `@rpath` install names so installed files don't reference the build tree
  patch do
    url "https://gitlab.com/samba-team/samba/-/commit/0da9389015101a855f4230a340165347f3f7b99c.diff"
    sha256 "089018252c79648a6e8227b5e05c2c859a211a60f1b30b0333606256e1e7f68d"
    type :unofficial
    resolves "https://gitlab.com/samba-team/samba/-/merge_requests/4729"
  end

  allow_network_access! :test

  def install
    # Skip building test that fails on ARM with error: initializer element is not a compile-time constant
    inreplace "lib/ldb/wscript", /\('test_ldb_comparison_fold',$/, "\\0 enabled=False," if Hardware::CPU.arm?

    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", buildpath/"lib/perl5"
      ENV.prepend_path "PATH", buildpath/"bin"
      resource("Parse::Yapp").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}"
        system "make"
        system "make", "install"
      end
    end
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/private" if OS.linux?
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac? # avoid openssl linkage

    bundled_libs_list = []
    # Upstream (https://github.com/lxin/quic) has no tagged releases, so we would have to add an arbitrary
    # commit as a resource. That's not really better than just using the vendored copy. Consider breaking
    # it out into a resource or formula once tagged releases become available.
    bundled_libs_list << "libquic" if OS.linux?
    bundled_libs = bundled_libs_list.empty? ? "NONE" : bundled_libs_list.join(",")

    # Don't use `std_configure_args` here
    # as configure script does not recognize
    # some options
    system "./configure",
           "--bundled-libraries=#{bundled_libs}",
           "--private-libraries=!ldb",
           "--disable-cephfs",
           "--disable-cups",
           "--disable-iprint",
           "--disable-glusterfs",
           "--disable-python",
           "--without-acl-support",
           "--without-ad-dc",
           "--without-ads",
           "--without-ldap",
           "--without-libarchive",
           "--without-json",
           "--without-pam",
           "--without-regedit",
           "--without-syslog",
           "--without-utmp",
           "--without-winbind",
           "--with-shared-modules=!vfs_snapper",
           "--with-system-mitkrb5",
           "--prefix=#{prefix}",
           "--libdir=#{lib}",
           "--sysconfdir=#{etc}",
           "--localstatedir=#{var}"
    system "make"
    system "make", "install"
    return unless OS.mac?

    # macOS has its own SMB daemon as /usr/sbin/smbd, so rename our smbd to samba-dot-org-smbd to avoid conflict.
    # samba-dot-org-smbd is used by qemu.rb .
    # Rename profiles as well to avoid conflicting with /usr/bin/profiles
    mv sbin/"smbd", sbin/"samba-dot-org-smbd"
    mv bin/"profiles", bin/"samba-dot-org-profiles"
  end

  def caveats
    on_macos do
      <<~EOS
        To avoid conflicting with macOS system binaries, some files were installed with non-standard name:
        - smbd:     #{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd
        - profiles: #{HOMEBREW_PREFIX}/bin/samba-dot-org-profiles
      EOS
    end
  end

  test do
    smbd = OS.mac? ? sbin/"samba-dot-org-smbd" : sbin/"smbd"

    system smbd, "--build-options", "--configfile=/dev/null"
    system smbd, "--version"

    mkdir_p "samba/state"
    mkdir_p "samba/data"
    (testpath/"samba/data/hello").write "hello"

    # mimic smb.conf generated by qemu
    # https://github.com/qemu/qemu/blob/v6.0.0/net/slirp.c#L862
    (testpath/"smb.conf").write <<~CONF
      [global]
      private dir=#{testpath}/samba/state
      interfaces=127.0.0.1
      bind interfaces only=yes
      pid directory=#{testpath}/samba/state
      lock directory=#{testpath}/samba/state
      state directory=#{testpath}/samba/state
      cache directory=#{testpath}/samba/state
      ncalrpc dir=#{testpath}/samba/state/ncalrpc
      log file=#{testpath}/samba/state/log.smbd
      smb passwd file=#{testpath}/samba/state/smbpasswd
      security = user
      map to guest = Bad User
      load printers = no
      printing = bsd
      disable spoolss = yes
      usershare max shares = 0
      [test]
      path=#{testpath}/samba/data
      read only=no
      guest ok=yes
      force user=#{ENV["USER"]}
    CONF

    port = free_port
    spawn smbd, "--debug-stdout", "-F", "--configfile=smb.conf", "--port=#{port}", "--debuglevel=4", in: "/dev/null"

    sleep 5
    mkdir_p "got"
    system bin/"smbclient", "-p", port.to_s, "-N", "//127.0.0.1/test", "-c", "get hello #{testpath}/got/hello"
    assert_equal "hello", (testpath/"got/hello").read
  end
end
