class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https://rpm.org/"
  url "http://ftp.rpm.org/releases/rpm-4.16.x/rpm-4.16.1.3.tar.bz2"
  mirror "https://ftp.osuosl.org/pub/rpm/releases/rpm-4.16.x/rpm-4.16.1.3.tar.bz2"
  sha256 "513dc7f972b6e7ccfc9fc7f9c01d5310cc56ee853892e4314fa2cad71478e21d"
  license "GPL-2.0-only"
  version_scheme 1

  livecheck do
    url "https://rpm.org/download.html"
    regex(/href=.*?rpm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur:      "cb96a7acd3064a24034996032a19c451f03ad1fede1c6a672331869220c4bc80"
    sha256 catalina:     "3f7de90218b2fbf8c42e63a4ae14f50244e058aff631e795197ac69e287a1d09"
    sha256 mojave:       "239cee186295db10924b8bf891a20c36169002d551389f934dec8b107df03ed6"
    sha256 x86_64_linux: "ffef7e6a8d2396046a1d642c543ad897820a399c5d1ec22c976cfdf64baa72a8"
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
  depends_on "xz"
  depends_on "zstd"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["lua"].opt_libexec/"lib/pkgconfig"
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
                          "--with-vendor=homebrew",
                          # Don't allow superenv shims to be saved into lib/rpm/macros
                          "__MAKE=/usr/bin/make",
                          "__SED=/usr/bin/sed",
                          "__GIT=/usr/bin/git",
                          "__LD=/usr/bin/ld"
    system "make", "install"

    inreplace lib/"rpm/macros", Superenv.shims_path, "" if OS.mac?
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
    assert_predicate testpath/"var/lib/rpm/Packages", :exist?,
                     "Failed to create 'Packages' file!"
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
