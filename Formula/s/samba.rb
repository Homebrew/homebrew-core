class Samba < Formula
  # Samba can be used to share directories with the guest in QEMU user-mode
  # (SLIRP) networking with the `-net nic -net user,smb=/share/this/with/guest`
  # option. The shared folder appears in the guest as "\\10.0.2.4\qemu".
  desc "SMB/CIFS file, print, and login server for UNIX"
  homepage "https://www.samba.org/"
  url "https://download.samba.org/pub/samba/stable/samba-4.23.3.tar.gz"
  sha256 "06cdbb27a6956978b045455fe0696d998ffbac8d24ba24de87a4ef8200813320"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/samba/download/"
    regex(/href=.*?samba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f90690906321e036be0fa6aa5b384a8e2b0b2f3459ab6705d29ab9ef26e843ad"
    sha256 arm64_sequoia: "d79512f5bde6f026b53a73ea6a6259f1ee1ae8ff3c6ac3d9f3bf3ea5607f2c46"
    sha256 arm64_sonoma:  "87e9d10d181fb0c9d2ae729e3fb83f9744489bbb7f24daca26679cd230a93fde"
    sha256 sonoma:        "9a0889c0691438278e36abcc8fd543a3707e01f2b38db80a01cdb50ba080e355"
    sha256 arm64_linux:   "9690405109131c6b3c76ecc3f1d940544b0fe540239248394bc07fb5a6005b47"
    sha256 x86_64_linux:  "3b2deef65bc456c32b690f9c856edfb79db9965ea1a61f7c7af6c54657d4e755"
  end

  depends_on "bison" => :build
  depends_on "cmocka" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  # icu4c can get linked if detected by pkg-config and there isn't a way to force disable
  # without disabling spotlight support. So we just enable the feature for all systems.
  depends_on "icu4c@78"
  depends_on "krb5"
  depends_on "libtasn1"
  depends_on "libxcrypt"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
  end

  on_linux do
    depends_on "libtirpc"
  end

  conflicts_with "jena", because: "both install `tdbbackup` binaries"
  conflicts_with "puzzles", because: "both install `net` binaries"

  resource "Parse::Yapp" do
    url "https://cpan.metacpan.org/authors/id/W/WB/WBRASWELL/Parse-Yapp-1.21.tar.gz"
    sha256 "3810e998308fba2e0f4f26043035032b027ce51ce5c8a52a8b8e340ca65f13e5"
  end

  # upstream bug report, https://bugzilla.samba.org/show_bug.cgi?id=10791
  # https://bugzilla.samba.org/show_bug.cgi?id=10626
  # https://bugzilla.samba.org/show_bug.cgi?id=9665
  # upstream pr ref, https://gitlab.com/samba-team/samba/-/merge_requests/3902
  patch do
    url "https://gitlab.com/samba-team/samba/-/commit/a2736fe78a4e75e71b9bc53dc24c36d71b911d2a.diff"
    sha256 "7d1bf9eb26211e2ab9e3e67ae32308a3704ff9904ab2369e5d863e079ea8a03f"
  end

  def install
    # Skip building test that fails on ARM with error: initializer element is not a compile-time constant
    inreplace "lib/ldb/wscript", /\('test_ldb_comparison_fold',$/, "\\0 enabled=False," if Hardware::CPU.arm?

    # avoid `perl module "Parse::Yapp::Driver" not found` error on macOS 10.xx (not required on 11)
    if !OS.mac? || MacOS.version < :big_sur
      ENV.prepend_create_path "PERL5LIB", buildpath/"lib/perl5"
      ENV.prepend_path "PATH", buildpath/"bin"
      resource("Parse::Yapp").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}"
        system "make"
        system "make", "install"
      end
    end
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/private" if OS.linux?

    bundled_libs_list = []
    # Upstream (https://github.com/lxin/quic) has no tagged releases, so we would have to add an arbitrary
    # commit as a resource. That's not really better than just using the vendored copy. Consider breaking
    # it out into a resource or formula once tagged releases become available.
    bundled_libs_list << "libquic" if OS.linux?
    bundled_libs = bundled_libs_list.empty? ? "NONE" : bundled_libs_list.join(",")

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
    smbd = if OS.mac?
      "#{sbin}/samba-dot-org-smbd"
    else
      "#{sbin}/smbd"
    end

    system smbd, "--build-options", "--configfile=/dev/null"
    system smbd, "--version"

    mkdir_p "samba/state"
    mkdir_p "samba/data"
    (testpath/"samba/data/hello").write "hello"

    # mimic smb.conf generated by qemu
    # https://github.com/qemu/qemu/blob/v6.0.0/net/slirp.c#L862
    (testpath/"smb.conf").write <<~EOS
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
    EOS

    port = free_port
    spawn smbd, "--debug-stdout", "-F", "--configfile=smb.conf", "--port=#{port}", "--debuglevel=4", in: "/dev/null"

    sleep 5
    mkdir_p "got"
    system bin/"smbclient", "-p", port.to_s, "-N", "//127.0.0.1/test", "-c", "get hello #{testpath}/got/hello"
    assert_equal "hello", (testpath/"got/hello").read
  end
end
