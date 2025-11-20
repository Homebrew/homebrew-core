class Unzip < Formula
  desc "Extraction utility for .zip compressed archives"
  homepage "https://infozip.sourceforge.net/UnZip.html"
  url "https://downloads.sourceforge.net/project/infozip/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz"
  version "6.0"
  sha256 "036d96991646d0449ed0aa952e4fbe21b476ce994abc276e49d30e686708bd37"
  license "Info-ZIP"
  revision 8

  livecheck do
    url :stable
    regex(%r{url=.*?(?:%20)?v?(\d+(?:\.\d+)+)/unzip\d+\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be1cb055cbcf3e1420ea25a48ab6da010c2e70efff5ffe7e4e91dac7231c4ae2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe1f7ac37950ec13dde20b2ab1eb86eb45f066a305df1fa6c8349d6de0e14dec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7bb9045e4d39a6409b1eaa113ccd21337374726d74a9b4b2344ea6a87f13543"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28765484286482079acb25eebf967819544b1a86daf3b92f6c19d282296e3915"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecb59929e280df14e71d9f163de7aa1613f005fb4d44dd40fc1a811ea5d61132"
    sha256 cellar: :any_skip_relocation, ventura:       "76363f884cbb100c668adea01a3d72a8efadc23e5bee125182ad030d6fd3685f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c82849237d428857a01410f203b89819f02e7ab28651400d6ebefe46f3feca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e3fe87c9f438d2012de977edf649608574a8c3265797fb693923bdca9227a7d"
  end

  keg_only :provided_by_macos

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"

  # Upstream is unmaintained so we use the Ubuntu patchset:
  # https://packages.ubuntu.com/noble/unzip
  patch do
    url "http://archive.ubuntu.com/ubuntu/pool/main/u/unzip/unzip_6.0-28ubuntu4.1.debian.tar.xz"
    sha256 "d123c8e6972dbdd17ba1a4920fb57ed2ede9237dbae149dcbf55df829c77baf3"
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
      patches/20-unzip60-alt-iconv-utf8.patch
      patches/21-fix-warning-messages-on-big-files.patch
      patches/22-cve-2019-13232-fix-bug-in-undefer-input.patch
      patches/23-cve-2019-13232-zip-bomb-with-overlapped-entries.patch
      patches/24-cve-2019-13232-do-not-raise-alert-for-misplaced-central-directory.patch
      patches/25-cve-2019-13232-fix-bug-in-uzbunzip2.patch
      patches/26-cve-2019-13232-fix-bug-in-uzinflate.patch
      patches/27-zipgrep-avoid-test-errors.patch
      patches/28-cve-2022-0529-and-cve-2022-0530.patch
    ]
  end

  def install
    # These macros also follow Ubuntu, and are required:
    # - to correctly handle large archives (> 4GB)
    # - extract & print archive contents with non-latin characters
    loc_macros = %w[
      -DLARGE_FILE_SUPPORT
      -DUNICODE_SUPPORT
      -DUNICODE_WCHAR
      -DUTF8_MAYBE_NATIVE
      -DNO_WORKING_ISPRINT
    ]
    cflags = ENV.cflags.to_s.split
    cflags << "-DNO_LCHMOD" unless OS.mac?
    args = %W[
      CC=#{ENV.cc}
      CFLAGS=#{cflags.join(" ")}
      LOC=#{loc_macros.join(" ")}
      D_USE_BZ2=-DUSE_BZIP2
      L_BZ2=-lbz2
    ]
    if OS.mac?
      args << "LFLAGS1=-liconv" << "macosx"
    else
      args << "unzips"
    end
    system "make", "-f", "unix/Makefile", *args
    system "make", "-f", "unix/Makefile", "prefix=#{prefix}", "MANDIR=#{man1}", "install"
  end

  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Hej!"

    if OS.mac?
      system "/usr/bin/zip", "test.zip", "test1", "test2", "test3"
    else
      system Formula["zip"].bin/"zip", "test.zip", "test1", "test2", "test3"
    end
    %w[test1 test2 test3].each do |f|
      rm f
      refute_path_exists testpath/f, "Text files should have been removed!"
    end

    system bin/"unzip", "test.zip"
    %w[test1 test2 test3].each do |f|
      assert_path_exists testpath/f, "Failure unzipping test.zip!"
    end

    assert_match "Hello!", File.read(testpath/"test1")
    assert_match "Bonjour!", File.read(testpath/"test2")
    assert_match "Hej!", File.read(testpath/"test3")
  end
end
