class Zip < Formula
  desc "Compression and file packaging/archive utility"
  homepage "https://infozip.sourceforge.net/Zip.html"
  url "https://downloads.sourceforge.net/project/infozip/Zip%203.x%20%28latest%29/3.0/zip30.tar.gz"
  version "3.0"
  sha256 "f0e8bb1f9b7eb0b01285495a2699df3a4b766784c1765a8f1aeedf63c0806369"
  license "Info-ZIP"
  revision 2
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/v?(\d+(?:\.\d+)+)/zip\d+\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "384ea7c636af67de3b5898885c7f24a79fbdc4409d17aaf41c968a3002b8e3b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d31ef9b8ca3f872979468ae9c81ecb927b9b71b78dbefc615377ae20cdf3ed1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf7b94eed4eb68d54de71566aac0c8bbde496d1e122c0124509055f3ffdcb0f1"
    sha256 cellar: :any,                 arm64_linux:       "93ecf509090250580953fc620ec602735c5ceb6acbb89c8f2d19f61ec7c1f096"
    sha256 cellar: :any,                 x86_64_linux:      "6e068e53a73085f4cbf4eb07707b1dee853f4f4071bda1c6ba6a4c73b16dce27"
  end

  keg_only :provided_by_macos

  uses_from_macos "bzip2"

  # Upstream is unmaintained so we use the Debian patchset:
  # https://packages.debian.org/sid/zip
  # Skipping fix-build-with-gcc-14.patch as may be glibc-only
  patch do
    url "https://deb.debian.org/debian/pool/main/z/zip/zip_3.0-16.debian.tar.xz"
    sha256 "fa79a0226f00f487b290489f62e1cd7f4a338df529a1e413fea4d168b8eee8f7"
    type :unofficial
    resolves "CVE-2018-13410",
             "https://bugs.debian.org/1143866"
    apply %w[
      patches/typo-it-is-transferring-not-transfering.patch
      patches/typo-it-is-privileges-not-priviliges.patch
      patches/manpages-in-section-1-not-in-section-1l.patch
      patches/do-not-set-unwanted-cflags.patch
      patches/typo-it-is-preceding-not-preceeding.patch
      patches/stack-markings-to-avoid-executable-stack.patch
      patches/fclose-in-file-not-fclose-x.patch
      patches/hardening-build-fix-1.patch
      patches/hardening-build-fix-2.patch
      patches/remove-build-date.patch
      patches/typo-it-is-ambiguities-not-amgibuities.patch
      patches/typo-it-is-os-2-not-risc-os-2.patch
      patches/buffer-overflow-unicode-filename.patch
      patches/buffer-overflow-cve-2018-13410.patch
      patches/fix-symlink-update-detection.patch
      patches/fix-command-injection.patch
    ]
  end

  # Fix compile with newer Clang
  # Otherwise configure thinks memset() and others are missing
  patch do
    file "Patches/zip/xcode15.diff"
    type :unofficial
  end

  deny_network_access!

  def install
    system "make", "-f", "unix/Makefile", "CC=#{ENV.cc}", "generic"
    system "make", "-f", "unix/Makefile", "BINDIR=#{bin}", "MANDIR=#{man1}", "install"
  end

  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Moien!"

    system bin/"zip", "test.zip", "test1", "test2", "test3"
    assert_path_exists testpath/"test.zip"
    # zip -T needs unzip, disabled under Linux to avoid a circular dependency
    assert_match "test of test.zip OK", shell_output("#{bin}/zip -T test.zip") if OS.mac?

    # test bzip2 support that should be automatically linked in using the bzip2 library in macOS
    system bin/"zip", "-Z", "bzip2", "test2.zip", "test1", "test2", "test3"
    assert_path_exists testpath/"test2.zip"
    # zip -T needs unzip, disabled under Linux to avoid a circular dependency
    assert_match "test of test2.zip OK", shell_output("#{bin}/zip -T test2.zip") if OS.mac?
  end
end
