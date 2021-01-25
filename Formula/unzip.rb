class Unzip < Formula
  desc "Extraction utility for .zip compressed archives"
  homepage "https://infozip.sourceforge.io/UnZip.html"
  url "https://downloads.sourceforge.net/project/infozip/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz"
  version "6.0"
  sha256 "036d96991646d0449ed0aa952e4fbe21b476ce994abc276e49d30e686708bd37"
  revision 6

  livecheck do
    url :stable
    regex(%r{url=.*?(?:%20)?v?(\d+(?:\.\d+)+)/unzip\d+\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2debed84387df5fd3430165b2e37046c73c141b2a7aedecfb3eb2ed06561556e" => :big_sur
    sha256 "f3dbb31f91250acb556aeb07b609decb690828cf1563ab6c63215217340c6fe9" => :arm64_big_sur
    sha256 "1fac8de0e83c5a91feb1fa6e007397be17918761345f900c0244ade19fea806c" => :catalina
    sha256 "908d05001d2692e21753508aae8cca95d588dcebc4f852f3a42e0b0b1e2df9d4" => :mojave
    sha256 "96e47f47a3c6b10d59d69f614b7c63ae0aeea1e553018ee398b1b5405d22a7f5" => :high_sierra
  end

  keg_only :provided_by_macos

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"

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
    args = %W[
      CC=#{ENV.cc}
      LOC=-DLARGE_FILE_SUPPORT
      D_USE_BZ2=-DUSE_BZIP2
      L_BZ2=-lbz2
      macosx
    ]
    on_macos do
      args << "LFLAGS1=-liconv"
    end
    system "make", "-f", "unix/Makefile", *args
    system "make", "prefix=#{prefix}", "MANDIR=#{man1}", "install"
  end

  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Hej!"

    on_macos do
      system "/usr/bin/zip", "test.zip", "test1", "test2", "test3"
    end
    on_linux do
      system Formula["zip"].bin/"zip", "test.zip", "test1", "test2", "test3"
    end
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
