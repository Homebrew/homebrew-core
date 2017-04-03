class Unzip < Formula
  desc "Extraction utility for .zip compressed archives"
  homepage "http://www.info-zip.org/pub/infozip/UnZip.html"
  url "https://downloads.sourceforge.net/project/infozip/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz"
  version "6.0"
  sha256 "036d96991646d0449ed0aa952e4fbe21b476ce994abc276e49d30e686708bd37"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "8033b925668362ae16383717f405e9a1aad8783c2df1e4d31efa447783a4d5eb" => :el_capitan
    sha256 "d8a9017d5a40202210c90e33e3994785268fe40faad222375e1335bc8e8a06d0" => :yosemite
    sha256 "d012cc29eb7447dfec5b1807f5b81aa622497d09bafd34a8329cddae91fecbee" => :mavericks
  end

  keg_only :provided_by_osx

  # Upstream is unmaintained so we use the Ubuntu unzip-6.0-20ubuntu1 patchset:
  # http://changelogs.ubuntu.com/changelogs/pool/main/u/unzip/unzip_6.0-20ubuntu1/changelog
  patch do
    url "https://launchpad.net/ubuntu/+archive/primary/+files/unzip_6.0-20ubuntu1.debian.tar.xz"
    mirror "https://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/u/unzip/unzip_6.0-20ubuntu1.debian.tar.xz"
    sha256 "0ddf122ef15b739e3ea06db4b9e80f40759dce23a2c886678881453a43bd0842"
    apply %w[
      patches/01-manpages-in-section-1-not-in-section-1l
      patches/02-branding-patch-this-is-debian-unzip
      patches/03-include-unistd-for-kfreebsd
      patches/04-handle-pkware-verification-bit
      patches/05-fix-uid-gid-handling
      patches/06-initialize-the-symlink-flag
      patches/07-increase-size-of-cfactorstr
      patches/08-allow-greater-hostver-values
      patches/09-cve-2014-8139-crc-overflow
      patches/10-cve-2014-8140-test-compr-eb
      patches/11-cve-2014-8141-getzip64data
      patches/12-cve-2014-9636-test-compr-eb
      patches/13-remove-build-date
      patches/14-cve-2015-7696
      patches/15-cve-2015-7697
      patches/16-fix-integer-underflow-csiz-decrypted
      patches/20-unzip60-alt-iconv-utf8
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
    system "#{bin}/unzip", "--help"
  end
end
