class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/65.21.tar.gz"
  sha256 "2e2d5b9476f9b84a0c4ca55d199682e5e06980de21a233c2714f6e91df198efe"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "391cf6d1d9d96972a8e97fd03c333054edda2f67285f9d603f5532d5627fd019"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0503e70a48a9f9dbaa7660c18b1d4849fc33797f8b9396c5d97dd13fcb47650"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58da9751a8cce539dfc7624d3a9ffb642e092ac50dc3a23ec80c83574052d010"
    sha256 cellar: :any,                 arm64_linux:       "5c208eb987ea579789cd443a368ee813bb3576a651a5437efbe650676fe67eeb"
    sha256 cellar: :any,                 x86_64_linux:      "3f6bcf423fdcc0573f7e04ca890ca5bdcb2e07716503dd1ad64b5c830110e5cf"
  end

  deny_network_access!

  def install
    bin.mkdir

    # JIT only works on Intel (might work on Linux aarch64, but not Apple Silicon)
    ENV.append_to_cflags "-DNOJIT" unless Hardware::CPU.intel?

    system "make", "install", "-f", "NONWINDOWS/Makefile", "PREFIX=#{prefix}"
    man1.install Utils::Gzip.compress("man/zpaqfranz.1")
  end

  test do
    output = shell_output("#{bin}/zpaqfranz autotest")
    assert_match "ERROR 0", output
  end
end
