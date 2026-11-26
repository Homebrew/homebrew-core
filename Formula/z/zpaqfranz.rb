class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/65.24.tar.gz"
  sha256 "da04b096dd3065f9f075e20803e26bc5a43b821f88c38026fa960cae4ddc1d70"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "61c06214d2dd56ac3608efe8a1b29170915ca576adb8684d53ea4c28f443b400"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "637bed2f0d067e0d1b6712164c29eb1a35709ebd78e8b9e176e3e19e294d18bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ae2c3508b0eab7e0fb46ecc93cf68aba82bf796fd5297b917058196eeee68cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "875b6c09a72b520e4e54e8696feda9d894212a27b05da8180e2fb21f98793e32"
    sha256 cellar: :any,                 arm64_linux:       "c62b58cd6f6fe9cf6c36a3a1ed6efedc343cc81ae296c423e1cc3b676911eb14"
    sha256 cellar: :any,                 x86_64_linux:      "1ce8522b244a71d81ca61e591dba859f22388c3ef89c52323c77f2ddc9a85cb8"
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
