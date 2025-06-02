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
    rebuild 3
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
      url "https://rpmfind.net/linux/fedora/linux/releases/39/Everything/x86_64/os/Packages/h/hello-2.12.1-2.fc39.x86_64.rpm"
      sha256 "10f9944f95ca54f224133cffab1cfab0c40e3adb64e4190d3d9e8f9dbed680f9"
    end

    testpath.install resource "homebrew-testdata"
    system bin/"rpm2cpio", "hello-2.12.1-2.fc39.x86_64.rpm"
  end
end
