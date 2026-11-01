class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/65.17.tar.gz"
  sha256 "d9ef4ac640dc164951361225ae20a4f857c44ea866ff2595240bfc34605b7d75"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b606f89dc541a6615906aea03df3c3a097bc253b1d46c2788c90455c2202fe1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4f5bc44880944f7427f37a1349d78b7b04b862f580a9eb8f71f288a1b7cd3b59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "188f12e0ae23ebf32f3523aec64aa69bc0dc21b0cd5dd6ab6e1032f472695c25"
    sha256 cellar: :any,                 arm64_linux:       "f8767c41181ec01be8199dea3439e8160bb40925f1a59824d7fecc86484817ad"
    sha256 cellar: :any,                 x86_64_linux:      "73423ed52aedc298922f86a05d7e74a34ecf2f7a32b2492122f1552b83d28298"
  end

  deny_network_access!

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
