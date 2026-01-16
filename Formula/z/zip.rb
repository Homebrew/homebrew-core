class Zip < Formula
  desc "Compression and file packaging/archive utility"
  homepage "https://infozip.sourceforge.net/Zip.html"
  url "https://downloads.sourceforge.net/project/infozip/Zip%203.x%20%28latest%29/3.0/zip30.tar.gz"
  version "3.0"
  sha256 "f0e8bb1f9b7eb0b01285495a2699df3a4b766784c1765a8f1aeedf63c0806369"
  license "Info-ZIP"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/v?(\d+(?:\.\d+)+)/zip\d+\.(?:t|zip)}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83ba2b2ec5dae0c7d6b804ee92e433ed035b1350d679592280c7421d15bd5a8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cdb35f0192184dbe0c83432f61cb35d2f640925b750bd8d07ea3de8ae1c2a71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "775099eb3b1a0f85dddef4df4ef0a596bf5224d9d715a5555c5009fdb55f95e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "be38fc0beefdd3c6f662e57bd31f997ddba8cfbce7bf8137128fe2865b06529c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e80a18894a12fc1771711c709cc20da6ac1d532d9fb10fbca79eb4165b026da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "526d0c20fa500e2440569e83d02643be31facbd1e788a2efceca7041a00f24d3"
  end

  keg_only :provided_by_macos

  uses_from_macos "bzip2"

  # Upstream is unmaintained so we use the Debian patchset:
  # https://packages.debian.org/sid/zip
  # Skipping 12-fix-build-with-gcc-14.patch as may be glibc-only
  patch do
    url "https://deb.debian.org/debian/pool/main/z/zip/zip_3.0-15.debian.tar.xz"
    sha256 "6dc1711c67640e8d1dee867ff53e84387ddb980c40885bd088ac98c330bffce9"
    apply %w[
      patches/01-typo-it-is-transferring-not-transfering.patch
      patches/02-typo-it-is-privileges-not-priviliges.patch
      patches/03-manpages-in-section-1-not-in-section-1l.patch
      patches/04-do-not-set-unwanted-cflags.patch
      patches/05-typo-it-is-preceding-not-preceeding.patch
      patches/06-stack-markings-to-avoid-executable-stack.patch
      patches/07-fclose-in-file-not-fclose-x.patch
      patches/08-hardening-build-fix-1.patch
      patches/09-hardening-build-fix-2.patch
      patches/10-remove-build-date.patch
      patches/11-typo-it-is-ambiguities-not-amgibuities.patch
      patches/13-typo-it-is-os-2-not-risc-os-2.patch
      patches/14-buffer-overflow-unicode-filename.patch
      patches/15-buffer-overflow-cve-2018-13410.patch
      patches/16-fix-symlink-update-detection.patch
    ]
  end

  # Fix compile with newer Clang
  # Otherwise configure thinks memset() and others are missing
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/zip/xcode15.diff"
    sha256 "99cb7eeeb6fdb8df700f40bfffbc30516c94774cbf585f725d81c3224a2c530c"
  end

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
