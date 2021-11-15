class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https://rpm.org/"
  url "http://ftp.rpm.org/releases/rpm-4.17.x/rpm-4.17.0.tar.bz2"
  mirror "https://ftp.osuosl.org/pub/rpm/releases/rpm-4.17.x/rpm-4.17.0.tar.bz2"
  sha256 "2e0d220b24749b17810ed181ac1ed005a56bbb6bc8ac429c21f314068dc65e6a"
  license "GPL-2.0-only"
  version_scheme 1

  livecheck do
    url "https://rpm.org/download.html"
    regex(/href=.*?rpm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur:      "6f857111ed59bf5efb8f97ad26c7ed52fb8e70a92d2978dc7d2f6173d14675cd"
    sha256 catalina:     "29846a4e13dd2683318362442fe7a84c2b7cd71813291be24cc356bc657f8a8d"
    sha256 mojave:       "aeab2644677216b3d631a4a1abb3d75aada85152f7f85a550ab43943b934f994"
    sha256 x86_64_linux: "1147c07948c53779fdf751623b349d6da6d6b4753103ce2c898da2cc68a0a041"
  end

  depends_on "berkeley-db"
  depends_on "gettext"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "libomp"
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "popt"
  depends_on "sqlite"
  depends_on "xz"
  depends_on "zstd"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-lomp"

    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace ["macros.in", "platform.in"], "@prefix@", HOMEBREW_PREFIX

    # ensure that pkg-config binary is found for dep generators
    inreplace "scripts/pkgconfigdeps.sh",
              "/usr/bin/pkg-config", Formula["pkg-config"].opt_bin/"pkg-config"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
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
                          "__LD=/usr/bin/ld"
    system "make", "install"

    # NOTE: We need the trailing `/` to avoid leaving it behind.
    inreplace lib/"rpm/macros", "#{Superenv.shims_path}/", ""
  end

  def post_install
    (var/"lib/rpm").mkpath

    if OS.mac?
      # Attempt to fix expected location of GPG to a sane default.
      inreplace lib/"rpm/macros", "/usr/bin/gpg2", HOMEBREW_PREFIX/"bin/gpg"
    end
  end

  def test_spec
    <<~EOS
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
      %install
      mkdir -p $RPM_BUILD_ROOT/tmp
      touch $RPM_BUILD_ROOT/tmp/test

      %files
      /tmp/test

      %changelog

    EOS
  end

  def rpmdir(macro)
    Pathname.new(`#{bin}/rpm --eval #{macro}`.chomp)
  end

  test do
    (testpath/"rpmbuild").mkpath

    (testpath/".rpmmacros").write <<~EOS
      %_topdir		#{testpath}/rpmbuild
      %_tmppath		%\{_topdir}/tmp
    EOS

    system "#{bin}/rpm", "-vv", "-qa", "--dbpath=#{testpath}/var/lib/rpm"
    assert_predicate testpath/"var/lib/rpm/rpmdb.sqlite", :exist?,
                     "Failed to create 'rpmdb.sqlite' file"
    rpmdir("%_builddir").mkpath
    specfile = rpmdir("%_specdir")+"test.spec"
    specfile.write(test_spec)
    system "#{bin}/rpmbuild", "-ba", specfile
    assert_predicate rpmdir("%_srcrpmdir")/"test-1.0-1.src.rpm", :exist?
    assert_predicate rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm", :exist?
    system "#{bin}/rpm", "-qpi", "--dbpath=#{testpath}/var/lib/rpm",
                         rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm"
  end
end
