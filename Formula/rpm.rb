class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https://rpm.org/"
  license "GPL-2.0-only"
  version_scheme 1
  head "https://github.com/rpm-software-management/rpm.git", branch: "master"

  stable do
    url "https://ftp.osuosl.org/pub/rpm/releases/rpm-4.18.x/rpm-4.18.1.tar.bz2"
    sha256 "37f3b42c0966941e2ad3f10fde3639824a6591d07197ba8fd0869ca0779e1f56"

    # Fix an "expected expression" error. Remove on next release.
    patch do
      url "https://github.com/rpm-software-management/rpm/commit/b960c0b43a080287a7c13533eeb2d9f288db1414.patch?full_index=1"
      sha256 "28417a368e4d4a6c722944a8fe325212b3cea96b6d355437c6366606a7ca0d00"
    end
  end

  livecheck do
    url "https://rpm.org/download.html"
    regex(/href=.*?rpm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura: "6705d70ecbc4e00acde775fb29b27a5b451e440b0e6c37d5bd539925fb1c5bc0"
    sha256 ventura:       "d48de12b7598c45696e25a5fce486fcb90f4eecf5a4e7224fead7d7592890299"
    sha256 x86_64_linux:  "98bb5f4798bc874e8fe11186bf96923c5adc5f68d35143616e7c001def9550fe"
  end

  depends_on "gettext"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "lua"
  depends_on macos: :ventura
  depends_on "openssl@3"
  depends_on "pkg-config"
  depends_on "popt"
  depends_on "sqlite"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "rpm2cpio", because: "both install `rpm2cpio` binaries"

  def install
    ENV.append "LDFLAGS", "-lomp" if OS.mac?

    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace ["macros.in", "platform.in"], "@prefix@", HOMEBREW_PREFIX

    # ensure that pkg-config binary is found for dep generators
    inreplace "scripts/pkgconfigdeps.sh",
              "/usr/bin/pkg-config", Formula["pkg-config"].opt_bin/"pkg-config"

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--localstatedir=#{var}",
                          "--sharedstatedir=#{var}/lib",
                          "--sysconfdir=#{etc}",
                          "--with-path-magic=#{HOMEBREW_PREFIX}/share/misc/magic",
                          "--enable-nls",
                          "--disable-plugins",
                          "--with-external-db",
                          "--with-crypto=openssl",
                          "--without-apidocs",
                          "--with-vendor=#{tap.user.downcase}",
                          # Don't allow superenv shims to be saved into lib/rpm/macros
                          "__MAKE=/usr/bin/make",
                          "__GIT=/usr/bin/git",
                          "__LD=/usr/bin/ld",
                          # GPG is not a strict dependency, so set stored GPG location to a decent default
                          "__GPG=#{Formula["gpg"].opt_bin}/gpg"

    system "make", "install"

    # NOTE: We need the trailing `/` to avoid leaving it behind.
    inreplace lib/"rpm/macros", "#{Superenv.shims_path}/", ""
    inreplace lib/"rpm/brp-remove-la-files", "--null", "-0"
  end

  def post_install
    (var/"lib/rpm").mkpath
    safe_system bin/"rpmdb", "--initdb" unless (var/"lib/rpm/rpmdb.sqlite").exist?
  end

  test do
    ENV["HOST"] = "test"
    (testpath/".rpmmacros").write <<~EOS
      %_topdir  %(echo $HOME)/rpmbuild
      %_tmppath	%_topdir/tmp
    EOS

    system bin/"rpmdb", "--initdb", "--root=#{testpath}"
    system bin/"rpm", "-vv", "-qa", "--root=#{testpath}"
    assert_predicate testpath/var/"lib/rpm/rpmdb.sqlite", :exist?,
                     "Failed to create 'rpmdb.sqlite' file"

    %w[SPECS BUILD BUILDROOT].each do |dir|
      (testpath/"rpmbuild/#{dir}").mkpath
    end
    specfile = testpath/"rpmbuild/SPECS/test.spec"
    specfile.write <<~EOS
      Summary:   Test package
      Name:      test
      Version:   1.0
      Release:   1
      License:   Public Domain
      Group:     Development/Tools
      BuildArch: noarch

      %description
      Trivial test package

      %prep
      %build
      echo "hello brew" > test

      %install
      install -d $RPM_BUILD_ROOT/%_docdir
      cp test $RPM_BUILD_ROOT/%_docdir/test

      %files
      %_docdir/test

      %changelog

    EOS
    system bin/"rpmbuild", "-ba", specfile
    assert_predicate testpath/"rpmbuild/SRPMS/test-1.0-1.src.rpm", :exist?
    assert_predicate testpath/"rpmbuild/RPMS/noarch/test-1.0-1.noarch.rpm", :exist?

    info = shell_output(bin/"rpm --query --package -i #{testpath}/rpmbuild/RPMS/noarch/test-1.0-1.noarch.rpm")
    assert_match "Name        : test", info
    assert_match "Version     : 1.0", info
    assert_match "Release     : 1", info
    assert_match "Architecture: noarch", info
    assert_match "Group       : Development/Tools", info
    assert_match "License     : Public Domain", info
    assert_match "Source RPM  : test-1.0-1.src.rpm", info
    assert_match "Trivial test package", info

    files = shell_output(bin/"rpm --query --list --package #{testpath}/rpmbuild/RPMS/noarch/test-1.0-1.noarch.rpm")
    assert_match (HOMEBREW_PREFIX/"share/doc/test").to_s, files
  end
end
