class Unzip < Formula
  desc "Extraction utility for .zip compressed archives"
  homepage "http://www.info-zip.org/pub/infozip/UnZip.html"
  url "https://downloads.sourceforge.net/project/infozip/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz"
  version "6.0"
  sha256 "036d96991646d0449ed0aa952e4fbe21b476ce994abc276e49d30e686708bd37"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "c69a3531f5c1c834132c89124e11e580cb052870515875240f035dd471977893" => :high_sierra
    sha256 "72cf9820bc8fe8c008bdb1cf7b231afbb0bc6b48511f4d40e5e4840f5bb5df65" => :sierra
    sha256 "8a2bfa62e728c9a9bc44d7acb9f34698e599b47f8200c45290b62502c682a6ec" => :el_capitan
    sha256 "3c69150f5a9ad6d1d1737eb17c06315dd7d0bc02b9c1a11e02ecb281c1e5f37f" => :yosemite
  end

  keg_only :provided_by_macos

  # Upstream is unmaintained so we use the Debian patchset:
  # https://packages.debian.org/sid/unzip
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/u/unzip/unzip_6.0-21.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/u/unzip/unzip_6.0-21.debian.tar.xz"
    sha256 "8accd9d214630a366476437a3ec1842f2e057fdce16042a7b19ee569c33490a3"
    apply %w[
      patches/01-manpages-in-section-1-not-in-section-1l.patch
      patches/02-this-is-debian-unzip.patch
      patches/03-include-unistd-for-kfreebsd.patch
      patches/04-handle-pkware-verification-bit.patch
      patches/05-fix-uid-gid-handling.patch
      patches/06-initialize-the-symlink-flag.patch
      patches/07-increase-size-of-cfactorstr.patch
      patches/08-allow-greater-hostver-values.patch
      patches/09-cve-2014-8139-crc-overflow.patch
      patches/10-cve-2014-8140-test-compr-eb.patch
      patches/11-cve-2014-8141-getzip64data.patch
      patches/12-cve-2014-9636-test-compr-eb.patch
      patches/13-remove-build-date.patch
      patches/14-cve-2015-7696.patch
      patches/15-cve-2015-7697.patch
      patches/16-fix-integer-underflow-csiz-decrypted.patch
      patches/17-restore-unix-timestamps-accurately.patch
      patches/18-cve-2014-9913-unzip-buffer-overflow.patch
      patches/19-cve-2016-9844-zipinfo-buffer-overflow.patch
    ]
  end

  def install
    system "make", "-f", "unix/Makefile",
      "CC=#{ENV.cc}",
      "LOC=-DLARGE_FILE_SUPPORT",
      "D_USE_BZ2=-DUSE_BZIP2",
      "L_BZ2=-lbz2",
      "macosx",
      "LFLAGS1=-liconv"
    system "make", "prefix=#{prefix}", "MANDIR=#{man1}", "install"
  end

  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Hej!"

    system "/usr/bin/zip", "test.zip", "test1", "test2", "test3"
    %w[test1 test2 test3].each do |f|
      rm f
      refute_predicate testpath/f, :exist?, "Text files should have been removed!"
    end

    system bin/"unzip", "test.zip"
    %w[test1 test2 test3].each do |f|
      assert_predicate testpath/f, :exist?, "Failure unzipping test.zip!"
    end

    assert_match "Hello!", File.read(testpath/"test1")
    assert_match "Bonjour!", File.read(testpath/"test2")
    assert_match "Hej!", File.read(testpath/"test3")
  end
end
