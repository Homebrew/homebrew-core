class Unzip < Formula
  desc "Extraction utility for .zip compressed archives"
  homepage "http://www.info-zip.org/pub/infozip/UnZip.html"
  url "https://downloads.sourceforge.net/project/infozip/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz"
  version "6.0"
  sha256 "036d96991646d0449ed0aa952e4fbe21b476ce994abc276e49d30e686708bd37"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "4bee41add2ec8cc7cce9e2e5ba150c3f9e9589a9b2f24fca6289abd2bfee3d1e" => :sierra
    sha256 "3535450cf720b5ad2fd76884339a190ad3e6f6083fbbd808c5a9337d805fc43a" => :el_capitan
    sha256 "c27e7f987cb4778d67caa8385dd93aa3343678ad17b58c74c5c108ed178fa098" => :yosemite
  end

  keg_only :provided_by_osx

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
    system "#{bin}/unzip", "--help"
  end
end
