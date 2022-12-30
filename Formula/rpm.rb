class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https://rpm.org/"
  url "https://ftp.osuosl.org/pub/rpm/releases/rpm-4.18.x/rpm-4.18.0.tar.bz2"
  sha256 "2a17152d7187ab30edf2c2fb586463bdf6388de7b5837480955659e5e9054554"
  license "GPL-2.0-only"
  version_scheme 1

  livecheck do
    url "https://rpm.org/download.html"
    regex(/href=.*?rpm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "f50bae938e1e727d9653ab655df667be722360ef0641d4e33435b9f5b1b2aada"
    sha256 arm64_monterey: "07c3b5a832fb5c1b75e2096a9146ca47d22750277414f98b4b3bb91c6ac01450"
    sha256 arm64_big_sur:  "4a4e308c175c19023fb3128ec13b0acca85e761c1a8a9e525e8c8e31dc74ae4f"
    sha256 ventura:        "0150063eb81f2e291de7c967597bf8a2ddbf4f86a781691fe448d5bfcb559a64"
    sha256 monterey:       "d12aac69e0a3306982c6327fa220a54b1a2f1a3224e09555a6af65fec5a43fc6"
    sha256 big_sur:        "f213bde4157208b400ad3927bbc694e2cbcd652c25ed4293e524793f62b0cb36"
    sha256 catalina:       "e7982bc9769b7fbfcb00da573dc3d4160a3ae95a9a68bf02d4bae2c4e10faee4"
    sha256 x86_64_linux:   "f2fbe2fec1f2d1212c2122560728929445e499f25df89cf8d623f04b993d5903"
  end

  depends_on "gettext"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "lua"
  depends_on macos: :ventura
  depends_on "openssl@1.1"
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

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

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
