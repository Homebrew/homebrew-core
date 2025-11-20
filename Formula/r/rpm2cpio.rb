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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2b5ac7e3d1f3d9db020bcf348931d3cb37930be23799168ec15b84fce0a8b9ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "57971030692fdb6757848c6febbfa2ee6b331287482019e45760328de8e03720"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfb382b55ce5155b2313bade20f110e59d9617e0d3ecedacb8d32e587800595d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25a31e16c6737137ab53e8c0768be89309f77d78e8ebb2a4ecf2a3bc9e1ee8fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bec9fc7497aea14f5ed7e57d4d56e0899b9fee2fc8d0773f6df1186e6b07327"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc05b2691766343ce66af5f1b1ab8e439c0370d4b8bb7d00ad7111a102f89659"
    sha256 cellar: :any_skip_relocation, ventura:        "0b59b750cefaa5e3e10b411be76ce61e6842ac5a33ae8fe2f9d5882748350db9"
    sha256 cellar: :any_skip_relocation, monterey:       "01c30bbc719f13559f1d351beeeca74b6e74a874ec79fdc2e461feec12bd199d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "122ec324ec52bf16746aa0aeb44cf01e0598ca3d7568e0abd54b8ba4cf33807f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a6ed93e8d9f082a0fda4538dcb4d94a75423e73d21ec86d5f1e0040a3e1b3c7"
  end

  depends_on "libarchive"
  depends_on "xz"

  conflicts_with "rpm", because: "both install `rpm2cpio` binaries"

  def install
    tar = OS.mac? ? "tar" : "bsdtar"
    inreplace "rpm2cpio", "tar", Formula["libarchive"].bin/tar
    bin.install "rpm2cpio"
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/github/gh-ost/releases/download/v1.1.7/gh-ost-1.1.7-1.x86_64.rpm"
      sha256 "9e7c91d07ccae51c653252b8c58c148032f3785223bfa8e531eba81aa912b71a"
    end

    testpath.install resource "homebrew-testdata"
    system bin/"rpm2cpio", "gh-ost-1.1.7-1.x86_64.rpm"
  end
end
