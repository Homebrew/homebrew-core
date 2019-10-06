class Unzip < Formula
  desc "Extraction utility for .zip compressed archives"
  homepage "https://infozip.sourceforge.io/UnZip.html"
  url "https://downloads.sourceforge.net/project/infozip/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz"
  version "6.0"
  sha256 "036d96991646d0449ed0aa952e4fbe21b476ce994abc276e49d30e686708bd37"
  revision 6

  bottle do
    cellar :any_skip_relocation
    sha256 "178cea56554b0e6b74856203340554c7615c6ed2e122059c78370e35c896f0ce" => :catalina
    sha256 "f0b95f2d5c664f45686f3aa318384906014ed28939da28020d12138f025aaeb6" => :mojave
    sha256 "6dd7d0862f5a8b954dd94b3c91378209e0086eec7c5be367af0d8c330bc099da" => :high_sierra
    sha256 "f4d59c04a44f93a30a23ec403784c73f9c06db9b72f3277679f66b1870a94331" => :sierra
  end

  keg_only :provided_by_macos

  # Upstream is unmaintained so we use the Debian patchset:
  # https://packages.debian.org/buster/unzip
  patch do
    url "https://deb.debian.org/debian/pool/main/u/unzip/unzip_6.0-25.debian.tar.xz"
    sha256 "0783e4d11d755cb43904e3f59a60dbb92ee9c6b08ac54d86bc61f9848216f37b"
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
      patches/20-cve-2018-1000035-unzip-buffer-overflow.patch
      patches/21-fix-warning-messages-on-big-files.patch
      patches/22-cve-2019-13232-fix-bug-in-undefer-input.patch
      patches/23-cve-2019-13232-zip-bomb-with-overlapped-entries.patch
      patches/24-cve-2019-13232-do-not-raise-alert-for-misplaced-central-directory.patch
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
