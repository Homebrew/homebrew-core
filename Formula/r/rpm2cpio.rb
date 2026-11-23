class Rpm2cpio < Formula
  desc "Tool to convert RPM package to CPIO archive"
  homepage "https://ports.freebsd.org/cgi/ports.cgi?stype=pkg&query=archivers%2frpm2cpio"
  url "https://raw.githubusercontent.com/freebsd/freebsd-ports/c72df716d4887488b758ffe09d763d5127682353/archivers/rpm2cpio/files/rpm2cpio"
  version "1.4"
  sha256 "2841bacdadde2a9225ca387c52259d6007762815468f621253ebb537d6636a00"
  license "BSD-2-Clause"
  compatibility_version 1

  livecheck do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/archivers/rpm2cpio/Makefile"
    regex(/^PORTVERSION=\s*?v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 4
    manifest_sha256 "6dd1b1f5f2b6f89cf9a8bbdef5be400470a2a070717f521d9c8b6fd2e39a0b9c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "635041390ce3ddafbcbcfeed3444476de152f1b5ff056930901bf2e38d3fe981"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e358f228d40752923527dcf212ca75d98b667ffbe1843074084198b6279bb222"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "224d2df5b4a45f241645a391b5987b53aeee76e47c216231cd639233adbaa10b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba5ea9dfa9fd07cd699ff18c6cf1fedfdf691700e86197ada2461c372c48a949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ba4899d9fecd9838550f203a48c738f2e3c7c6d4617d85b3e008ab50c41ac429"
  end

  depends_on "libarchive"
  depends_on "xz"

  conflicts_with "rpm", because: "both install `rpm2cpio` binaries"

  resource "homebrew-testdata", :test do
    url "https://github.com/github/gh-ost/releases/download/v1.1.7/gh-ost-1.1.7-1.x86_64.rpm"
    sha256 "9e7c91d07ccae51c653252b8c58c148032f3785223bfa8e531eba81aa912b71a"
  end

  deny_network_access!

  def install
    inreplace "rpm2cpio", "tar", formula_opt_bin("libarchive")/"bsdtar"
    bin.install "rpm2cpio"
  end

  test do
    testpath.install resource "homebrew-testdata"
    system bin/"rpm2cpio", "gh-ost-1.1.7-1.x86_64.rpm"
  end
end
