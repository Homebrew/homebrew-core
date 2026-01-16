class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/63.8.tar.gz"
  sha256 "20406c45b67c3f3a6c3071751d9df550e2e2d2c79c7ada2371063e8aafbeda16"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e67086e7954d4ee4a8f946982fbe74246f33bcade8101e637e6c6a6966d7616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6abac85c303bfd4b3e8a7595cde583bf511c46e18dfe15e0b55b29ebcf071a0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3ac7c17f0a6df0b918c93aff99f9ddbdaaf5936e44d698b9ad5260022eb85d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad55fa92cfe36ac1c94e1a741d8b07bfbb26972d0a59119dc1a3ad4336431987"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d757a3d52c3ad2d931fbc24f3615f6ecd1688ae04874650c06c5e4432b388637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a6b61d598272da99f5ffe52d78bbfa9263ae08726f401ae213a247e93a2d639"
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
