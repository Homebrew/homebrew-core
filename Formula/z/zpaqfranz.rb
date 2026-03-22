class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/64.6.tar.gz"
  sha256 "2a623c2dc2343bfc7d12fcf0079f713dec2d856e72fb4494e57e0505464d3c22"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "067482f5c100dc9af1ec49412a535747871ea9f4956c1a496021fa54c32c041b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "819eeb2ef41b8f1cc5939cc35ef386e80bbfeef6d6ef2f480593116aa35e2b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55268f0df90d37b99257df1aca7395e1e53dd6564038e616798cb909a32d2f10"
    sha256 cellar: :any_skip_relocation, sonoma:        "6310bb0259ed5453abc71a6afa9ef4a3ec7d5927f7b05862b19f8243da9c0922"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bc3a218d3d1635022597b14eff59e436fcb7d4f24591b0e5d60ea41804debb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab5610ce71a03b0016d55ad5305aec5bf7e005c567c4395469e8848d052b4bcb"
  end

  def install
    bin.mkdir

    # JIT only works on Intel (might work on Linux aarch64, but not Apple Silicon)
    ENV.append_to_cflags "-DNOJIT" unless Hardware::CPU.intel?

    system "make", "install", "-f", "NONWINDOWS/Makefile", "BINDIR=#{bin}/#{name}"
    man1.install Utils::Gzip.compress("man/zpaqfranz.1")
  end

  test do
    output = shell_output("#{bin}/zpaqfranz autotest")
    assert_match "ERROR 0", output
  end
end
