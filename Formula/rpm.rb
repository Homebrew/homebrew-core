class RpmDownloadStrategy < CurlDownloadStrategy
  def stage
    tarball_name = "#{name}-#{version}.tar.gz"
    safe_system "rpm2cpio.pl <#{cached_location} | cpio -vi #{tarball_name}"
    safe_system "/usr/bin/tar -xzf #{tarball_name} && rm #{tarball_name}"
    chdir
  end

  def ext
    ".src.rpm"
  end
end

class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "http://www.rpm5.org/"
  url "http://rpm5.org/files/rpm/rpm-5.4/rpm-5.4.15-0.20140824.src.rpm",
      :using => RpmDownloadStrategy
  version "5.4.15"
  sha256 "d4ae5e9ed5df8ab9931b660f491418d20ab5c4d72eb17ed9055b80b71ef6c4ee"
  revision 2

  bottle do
    sha256 "a3c01318b36b61c27dafa2c2e2fdc4f47a3b4dd0711e40f38f005a9a011d8958" => :sierra
    sha256 "b0c2b8f564ce9a39ba6ba4287906b426420a23689105e381b684c812ba4372fe" => :el_capitan
    sha256 "29bc65fb2f35846f07630b4b38099723ffd920ca6569e4ee72c495bda38ebcc2" => :yosemite
  end

  depends_on "rpm2cpio" => :build
  depends_on "berkeley-db"
  depends_on "libmagic"
  depends_on "popt"
  depends_on "libtasn1"
  depends_on "gettext"
  depends_on "xz"
  depends_on "ossp-uuid"

  def install
    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace "macros/macros.in", "@prefix@", HOMEBREW_PREFIX
    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --with-path-cfg=#{etc}/rpm
      --with-path-magic=#{HOMEBREW_PREFIX}/share/misc/magic
      --with-path-sources=#{var}/lib/rpmbuild
      --with-libiconv-prefix=/usr
      --disable-openmp
      --disable-nls
      --disable-dependency-tracking
      --with-db=external
      --with-sqlite=external
      --with-file=external
      --with-popt=external
      --with-beecrypt=internal
      --with-libtasn1=external
      --with-neon=internal
      --with-uuid=external
      --with-pcre=internal
      --with-lua=internal
      --with-syck=internal
      --without-apidocs
      varprefix=#{var}
    ]

    system "./configure", *args
    inreplace "Makefile", "--tag=CC", "--tag=CXX"
    inreplace "Makefile", "--mode=link $(CCLD)", "--mode=link $(CXX)"
    system "make"
    # enable rpmbuild macros, for building *.rpm packages
    inreplace "macros/macros", "#%%{load:%{_usrlibrpm}/macros.rpmbuild}", "%{load:%{_usrlibrpm}/macros.rpmbuild}"
    # using __scriptlet_requires needs bash --rpm-requires
    inreplace "macros/macros.rpmbuild", "%_use_internal_dependency_generator\t2", "%_use_internal_dependency_generator\t1"
    system "make", "install"
  end

  def test_spec
    <<-EOS.undent
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
    (testpath/".rpmmacros").write <<-EOS.undent
      %_topdir		#{testpath}/rpmbuild
      %_tmppath		%{_topdir}/tmp
    EOS

    system "#{bin}/rpm", "-vv", "-qa", "--dbpath=#{testpath}/var/lib/rpm"
    assert File.exist?(testpath/"var/lib/rpm/sqldb"), "Failed to create 'sqldb' file!"
    assert_match "Packages", shell_output("sqlite3 #{testpath}/var/lib/rpm/sqldb <<< .tables")
    rpmdir("%_builddir").mkpath
    specfile = rpmdir("%_specdir")+"test.spec"
    specfile.write(test_spec)
    system "#{bin}/rpmbuild", "-ba", specfile
    assert File.exist?(rpmdir("%_srcrpmdir")/"test-1.0-1.src.rpm")
    assert File.exist?(rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm")
    system "#{bin}/rpm", "-qpi", "--dbpath=#{testpath}/var/lib/rpm",
                         rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm"
  end
end
