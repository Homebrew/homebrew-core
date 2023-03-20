class Rpm2cpio < Formula
  desc "Tool to convert RPM package to CPIO archive"
  homepage "https://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/"
  url "https://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/files/rpm2cpio?revision=408590&view=co"
  version "1.4"
  sha256 "2841bacdadde2a9225ca387c52259d6007762815468f621253ebb537d6636a00"
  license "BSD-2-Clause"

  livecheck do
    url "https://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/Makefile?view=co"
    regex(/^PORTVERSION=\s*?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0d766ccb938671a8c732670ae21369f7213ff1c75bcbae8dd3375043ca7a0f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dc679df047764833091737b1c6abe53f76788281df5fa220ff0914cf5f7bde6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4048459b1dce919e2cdbb30b79b7893a5ebac6edf34ec82bc7ac224836b06c5"
    sha256 cellar: :any_skip_relocation, ventura:        "d23abbffe4e9bb974d7be5a6e07ba8105b641a01cbd924d439b87a9824849deb"
    sha256 cellar: :any_skip_relocation, monterey:       "d93f7543c723d33c9cc2666bfe057583889d60d4d250f4f6921e1844a652043e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a704cd7500da1e5ee5da24db92d732212c7d3e1106ab7dd54888f5fcb681475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a5a71b883b56d4c4188946221d349a9e0bdbc5f2f1a835df26b0504c439b335"
  end

  depends_on "libarchive"
  depends_on "xz"

  conflicts_with "rpm", because: "both install `rpm2cpio` binaries"

  resource "homebrew-testdata" do
    url "https://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/h/hello-2.10-9.fc38.x86_64.rpm"
    sha256 "59a4cb33a7f59d00153a0d8c726d3e02b03d8bcb6f90e1a9348bc019258a26c8"
  end

  def install
    tar = OS.mac? ? "tar" : "bsdtar"
    inreplace "rpm2cpio", "tar", Formula["libarchive"].bin/tar
    bin.install "rpm2cpio"
  end

  test do
    resource("homebrew-testdata").stage do
      system "#{bin}/rpm2cpio", "hello-2.10-9.fc38.x86_64.rpm"
    end
  end
end
